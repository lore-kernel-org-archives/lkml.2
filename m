Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab2EOPGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:06:03 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:47828 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932763Ab2EOPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:06:00 -0400
Message-ID: <4FB270D2.8030705@fold.natur.cuni.cz>
Date: Tue, 15 May 2012 17:05:54 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Jean-Louis Dupond <jean-louis@dupond.be>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Kamal Mostafa <kamal@canonical.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
References: <1337023652-11661-1-git-send-email-kamal@canonical.com> <20120514193718.GA6438@srcf.ucam.org> <4FB16659.6040704@dell.com> <20120514211959.GA9394@srcf.ucam.org> <4FB1774D.4080106@dell.com> <20120514212842.GA9561@srcf.ucam.org> <4FB17DA8.1040808@dell.com> <20120514215533.GA10378@srcf.ucam.org> <4FB182BB.6090303@dupond.be>
In-Reply-To: <4FB182BB.6090303@dupond.be>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Louis Dupond wrote:
> Hi
> 
> I'm the owner of a XPS 15, which has this issue.
> The best solution would indeed be to solve the real bug, and not work
> around it in Linux.
> 
> But still, if we can fix it with rather small impact/code on linux, I
> think we should just do it.
> It makes linux more user friendly this way.
> 
> A small remark also:
> Is it really possible to disable bluetooth without killing wifi in
> Windows on the XPS?

I rebooted into Win7. You are right, on this Dell Vostro 3550 the Fn+F2 has
only two states: turn on both BT+WiFi or turn both off. My old ASUS laptop
had 3 states and I could turn off independently BT while not WiFi. ;) 
So, rfkill application on Linux behaves in the same way as the Fn+F2 in Linux
and in Win 7.

Martin
