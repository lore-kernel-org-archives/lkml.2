Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab2EUQwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:52:33 -0400
Received: from mail.bitdefender.com ([91.199.104.2]:57770 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2EUQwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:52:31 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2012 12:52:31 EDT
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
X-BitDefender-Spam: No (0)
X-BitDefender-SpamStamp: Build: [Engines: 2.13.1.14553, Dats: 200504,
 Stamp: 3], Multi: [Enabled], BW: [Enabled], RBL DNSBL: [Enabled,
 Score: 0(0)], APM: [Enabled, Score: 500], SGN: [Enabled], URL:
 [Enabled], URI DNSBL: [Disabled], SQMD: [Enabled, Hits: none, MD5:
 dde69a39aade4a0b2cfc8637504d3d22.fuzzy.fzrbl.org], RTDA: [Disabled,
 Hit: No], total: 0(775)
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.1.0 on
 elfie.dsd.hq, sigver: 7.42342
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=gmail.com;
  b=mbN7A+0pHfpolu2nJaHhMd2W4il2zTotUAf/uNc2InIcWPhfLsFhVer/nt0zhw4mWw0T+N2We6mVqlPsaBELCnyJj7BlIeaJqlmH57CfeDtpwS8+8rSSG1uuPgF7JhMJ2UHmqUmzojzsmJYepTJnTCp6R3F0mioxH3YbvRol7/c=  ;
Date: Mon, 21 May 2012 19:45:48 +0300
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: ivo.welch@gmail.com
Cc: ivo.welch@anderson.ucla.edu, linux-kernel@vger.kernel.org
Subject: Re: the easy way to sandbox?
Message-ID: <20120521194548.716cdf8e@mdontu-l>
In-Reply-To: <CAPr7RtUBDn01qDkxvcLO8ZckAtTmCCJk7hCjwH4_XziwXtAS6Q@mail.gmail.com>
References: <CAPr7RtUBDn01qDkxvcLO8ZckAtTmCCJk7hCjwH4_XziwXtAS6Q@mail.gmail.com>
Organization: Home
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012 09:28:13 -0700 ivo welch wrote:
> Suggestion:  introduce a system call that eliminates access to all
> real file systems for the current process.  the only permissible
> interaction would be stdin, stdout, and stderr.
> 
> this would make it very simple to write a sandboxed safe fcgi script.
> the script could load all the dynamic libraries and data it wants, and
> then call this no-more-filesystem-access feature (preferably allowable
> without root privileges).  thereafter, even if a hacker takes control
> of the script, not much permanent damage can happen.
> 
> right now, it is much more complex to accomplish this---which is why
> sandboxing cgi scripts is not used too often.
> 

Check this out: http://en.wikipedia.org/wiki/Seccomp

-- 
Mihai Donțu
