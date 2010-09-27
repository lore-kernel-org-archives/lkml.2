Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab0I0GEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:04:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39851 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab0I0GEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:in-reply-to:references:user-agent:date:message-id
         :mime-version:content-type:content-transfer-encoding;
        b=EF7zh2gC1NwBqMv4qy1dKZu4uff0+vPAo36w69Mci/wwMGmEA/2IMGeHfRDBhCzdeB
         aHaY8miK7yqhAARzfmmu2lcy4qp2x6hrX5Ddeo+NxiLGKpg6/me2PQPDwW6Pj1bcJej0
         aHD2+TDPtbtugpNx1l1Xn+ISIP1+uME93xHQ8=
From: Ben Gamari <bgamari@gmail.com>
To: Raymond Liu <raymondliu3linux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: HDMI open source to handle audio/video/CEC in one driver
In-Reply-To: <AANLkTi=mLizQGyp5cdR_WtHjMMhixBOOagkFUNVqO4vj@mail.gmail.com>
References: <AANLkTimMH604FW_NZehY68w8B_cV_Lhe-ZwZq0cAYUfd@mail.gmail.com> <AANLkTi=mLizQGyp5cdR_WtHjMMhixBOOagkFUNVqO4vj@mail.gmail.com>
User-Agent: Notmuch/0.3.1-62-g4723706 (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Mon, 27 Sep 2010 02:04:09 -0400
Message-ID: <8739svu3hi.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Sep 2010 22:40:12 -0700, Raymond Liu <raymondliu3linux@gmail.com> wrote:
> Hi,
> 
> My company is working on the Linux HDMI open source driver for our
> chipsets (with audio/video/CEC controls).  Is there any similar
> project ongoing for this kind of driver in Linux community?  Who
> should I contact with for this?
> 
I believe the Linux Driver Project[1] might be a helpful starting
point. This project was formed with the goal of interacting with
hardware vendors who are interested in getting their devices supported
by Linux. Good luck!

- Ben
