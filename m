Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0KZM7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:59:24 -0500
Received: from canuck.infradead.org ([134.117.69.58]:41478 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab0KZM7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:59:23 -0500
Subject: Re: [rfc 1/3] perf, x86: P4 PMU - describe config format
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, ming.m.lin@intel.com
In-Reply-To: <AANLkTikjEDVmQRt4ZxwwXJznX2X3zSqSY=zoPtuN1omY@mail.gmail.com>
References: <20101123224601.766827604@openvz.org>
	 <20101123224800.294919307@openvz.org>
	 <AANLkTikjEDVmQRt4ZxwwXJznX2X3zSqSY=zoPtuN1omY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 26 Nov 2010 13:59:39 +0100
Message-ID: <1290776379.2145.143.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 13:48 +0100, Stephane Eranian wrote:
> Reviewed-by: Stephane Eranian <eranian@google.com>

The new one, right? The one that reads:

+ *    Low 32 bits
+ *    -----------
+ *      0-6: P4_PEBS_METRIC enum
+ *     7-11:                    reserved
+ *       12:                    reserved (Enable)
+ *    13-15:                    reserved (ESCR select)
+ *    16-17: Active Thread
+ *       18: Compare
+ *       19: Complement
+ *    20-23: Threshold
+ *       24: Edge
+ *       25:                    reserved (FORCE_OVF)
+ *       26:                    reserved (OVF_PMI_T0)
+ *       27:                    reserved (OVF_PMI_T1)
+ *    28-29:                    reserved
+ *       30:                    reserved (Cascade)
+ *       31:                    reserved (OVF)
+ *
+ *    High 32 bits
+ *    ------------
+ *        0:                    reserved (T1_USR)
+ *        1:                    reserved (T1_OS)
+ *        2:                    reserved (T0_USR)
+ *        3:                    reserved (T0_OS)
+ *        4: Tag Enable
+ *      5-8: Tag Value
+ *     9-24: Event Mask (may use P4_ESCR_EMASK_BIT helper)
+ *    25-30: enum P4_EVENTS
+ *       31:                    reserved (HT thread)

