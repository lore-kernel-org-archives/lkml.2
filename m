Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab1BCSVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:21:52 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49321 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab1BCSVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:21:52 -0500
MIME-Version: 1.0
In-Reply-To: <20110203163442.GB3712@dumpdata.com>
References: <AANLkTi=r2s6QmBz1bsrsn5GHanQs+sQ73sPDKuBVe6tw@mail.gmail.com>
	<20110203163442.GB3712@dumpdata.com>
Date: Thu, 3 Feb 2011 10:21:50 -0800
Message-ID: <AANLkTi=uje9t_uEMP1y7cfrGYWPPw8G0HidT7HvYNVkQ@mail.gmail.com>
Subject: Re: Xen DomU kernel BUG on 2.6.37
From: Anirban Sinha <ani@anirban.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 8:34 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Wed, Feb 02, 2011 at 05:19:45PM -0800, Anirban Sinha wrote:
>> Hi :
>>
>> I have compiled a custom DomU kernel and tried booting with it on a
>
> This custom thing is not healthy. We need a baseline (say a vanilla
> kernel from ftp.kernel.org).

By custm, I meant that the domU kernel did not ship with any distro
like fedora or Ubuntu etc. Otherwise, it is a stock 2.6.37 kernel.org
kernel that I downloaded, configured and built. There are no private
patches in this kernel.

>
> However, I am curious to see how this works for you when you
> use the patch that Ian suggested to you for 2.6.32?
>

I'll try it and let you know.
