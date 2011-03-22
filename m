Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1CVSH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:07:26 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60299 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1CVSHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qpxtKCkmT9qVHNsBrGRFho/YELDpOBF8OAWJx/5rrMNnQGDojSLWE0yhTEPEX0DLPH
         czpaMi7tnZSy1DeEZ8zg==
MIME-Version: 1.0
In-Reply-To: <4D8873DD.80800@cn.fujitsu.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
	<1300756245-12380-2-git-send-email-ctalbott@google.com>
	<4D8873DD.80800@cn.fujitsu.com>
Date: Tue, 22 Mar 2011 11:07:19 -0700
Message-ID: <AANLkTinDEa-whKTk0hP81x=Ag-2cXOheBjRPF=2b=B7r@mail.gmail.com>
Subject: Re: [PATCH 1/3] cfq-iosched: Fair cross-group preemption (interface
 and documentation)
From: Chad Talbott <ctalbott@google.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: jaxboe@fusionio.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
        mrubin@google.com, teravest@google.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 3:03 AM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
> Do we need to implement a globle blkio.class interface as well as
> a device specific one something like "blkio.class_device"? So a user
> doesn't need to check every device number if he want to specify a
> global value.

I think you're right.  It's more symmetrical with the weight
interface, so will be less confusing.  I'll add it.

Chad
