Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab0JFKSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:18:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38629 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0JFKSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mssdnvmwZ+Alqy6OV7Fp665e307RevmrGL+EENF8eBrp/IaktZBszm1h+cI63Q3Lo+
         U8LIHjVOFTPjF1X32x+llh9tIhFVC5FobBIQyZamH09haI6cx8t8p4GLqKMR1ONiue4K
         FRCcsehy2+Y9fthTV/QAe4/1y0TGb6VH9YvVE=
Date: Wed, 6 Oct 2010 18:23:11 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Artur Baruchi <mail.baruchi@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Information From Buffers
Message-ID: <20101006102311.GA5724@cr0.nay.redhat.com>
References: <AANLkTik-RXPfDK12m5OFmLf=gVL1x-h-aDcKX2nz6O3P@mail.gmail.com>
 <20101004101200.GI5189@cr0.nay.redhat.com>
 <AANLkTi=UDned6J0SbcFAfsiF1rg=E-+ZUE2TN=KOg0-f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=UDned6J0SbcFAfsiF1rg=E-+ZUE2TN=KOg0-f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 08:04:24AM -0300, Artur Baruchi wrote:
>Hi Wang.
>
>Thanks for your reply.
>
>No, inside /proc/meminfo there are just high level information (macro)
>about what is going on inside the memory. I need do get more details
>about page cache, things like, what files are being buffered, how much
>files are being buffered, size of this files, etc. This information
>can be reach using buffer_head linked list, but I dont know how to
>walk through this list.
>


I see, seems we can't get this kind of informantion from /proc.

Oracle has a tool for this, check:

http://oss.oracle.com/projects/codefragments/dist/files/pagecache-info/pagecache-info

Hope it can help.

Thanks.
