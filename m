Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0KZNHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:07:24 -0500
Received: from smtp-out.google.com ([74.125.121.35]:3293 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0KZNHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:07:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hZnjH6Yg189J5dc1lRI7XnIxisPdt63pPkCswBirlRd3vRfM1MWpBSd5IcXriTW4iC
         Z8WpQbr00dqt8JDUKc2Q==
MIME-Version: 1.0
In-Reply-To: <1290776379.2145.143.camel@laptop>
References: <20101123224601.766827604@openvz.org>
	<20101123224800.294919307@openvz.org>
	<AANLkTikjEDVmQRt4ZxwwXJznX2X3zSqSY=zoPtuN1omY@mail.gmail.com>
	<1290776379.2145.143.camel@laptop>
Date: Fri, 26 Nov 2010 14:07:13 +0100
Message-ID: <AANLkTinSSXzUVPpq2F3G8cxLNdQFJSgbxw+prkj6Pw3a@mail.gmail.com>
Subject: Re: [rfc 1/3] perf, x86: P4 PMU - describe config format
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, ming.m.lin@intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAQD7WhC024027

On Fri, Nov 26, 2010 at 1:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-11-26 at 13:48 +0100, Stephane Eranian wrote:
>> Reviewed-by: Stephane Eranian <eranian@google.com>
>
> The new one, right? The one that reads:
>
Yes. Sorry about that.

> + *    Low 32 bits
> + *    -----------
> + *      0-6: P4_PEBS_METRIC enum
> + *     7-11:                    reserved
> + *       12:                    reserved (Enable)
> + *    13-15:                    reserved (ESCR select)
> + *    16-17: Active Thread
> + *       18: Compare
> + *       19: Complement
> + *    20-23: Threshold
> + *       24: Edge
> + *       25:                    reserved (FORCE_OVF)
> + *       26:                    reserved (OVF_PMI_T0)
> + *       27:                    reserved (OVF_PMI_T1)
> + *    28-29:                    reserved
> + *       30:                    reserved (Cascade)
> + *       31:                    reserved (OVF)
> + *
> + *    High 32 bits
> + *    ------------
> + *        0:                    reserved (T1_USR)
> + *        1:                    reserved (T1_OS)
> + *        2:                    reserved (T0_USR)
> + *        3:                    reserved (T0_OS)
> + *        4: Tag Enable
> + *      5-8: Tag Value
> + *     9-24: Event Mask (may use P4_ESCR_EMASK_BIT helper)
> + *    25-30: enum P4_EVENTS
> + *       31:                    reserved (HT thread)
>
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
