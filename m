Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1BAH1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 02:27:42 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37877 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1BAH1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 02:27:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qZ1TJxlE9XVuc01di3ObFjMtQrzWBw82R2vkka5qbxGcAsjOwAJUMmcdBsWkkihqIn
         itU8fG6mYENVogRSIAMmYXmF5XTcqRuXa+jCtiernHvshAmeNRFm/2GtMVgsTN6j4g8m
         kv2jApb/lm5UVBS6pL/xCVas0gMgUaECIO7SU=
Date: Tue, 1 Feb 2011 15:19:50 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kosaki.motohiro@jp.fujitsu.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Message-ID: <20110201071933.GA21239@cr0.nay.redhat.com>
References: <20110131225939.GH11974@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131225939.GH11974@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 05:59:39PM -0500, Vivek Goyal wrote:
>
>Anyway, if an image is loaded and we have setup to capture dump also
>why do we need to save kmsg with the help of an helper. I am assuming
>this is more of a debugging aid if we have no other way to capture the
>kernel log buffer. So if somebody has setup kdump to capture the
>vmcore, why to call another handler which tries to save part of the
>vmcore (kmsg) separately.
>

Well, kmsg dumper is not only for panic/oops, it can also save kernel
messages when the system is reboot/halt.

Yeah, it is true that vmcore contains log_buf, but I think the users
of ramoops/mtdoops are mainly those who don't have kdump configured
in their kernels, they are cheaper than kdump, but less powerful.

Thanks.
