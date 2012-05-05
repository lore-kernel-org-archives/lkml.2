Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2EEIy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:54:57 -0400
Received: from smtp.fullrate.dk ([90.185.1.42]:54208 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab2EEIy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:54:56 -0400
Message-ID: <4FA4EACA.6040405@molgaard.org>
Date: Sat, 05 May 2012 10:54:34 +0200
From: =?ISO-8859-1?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/15.0 Firefox/15.0a1 SeaMonkey/2.12a1
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: linux-kernel@vger.kernel.org
Subject: Re: Boot failure since 3.3-rc?
References: <4F931C6D.8040407@molgaard.org> <CAE9FiQVSWSNt6MVGU6MiHozpcbjyzukvM++E5kEv5BSsS-nbzw@mail.gmail.com> <4F932506.8040606@molgaard.org> <4F952F2E.6050503@imap.cc>
In-Reply-To: <4F952F2E.6050503@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Am 21.04.2012 23:22, schrieb Sune Mølgaard:
>> Need to read up on netconsole as it's a headless machine. Would
>> netconsole work through a switch, or would I need to find a cross-over
>> cable?
>
> Netconsole works fine through a switch.
>

Thank you. If, as per my last post, the offending commit is instead 
about i387, my guess would be that the kernel hangs immediately, way 
before init'ing the NIC.

The machine is rather old, but if it has sufficient NVRAM, is there a 
way to log failures (perhaps via grub) to there, and then retrieve them 
when booting a known good kernel?

Best,

Sune

-- 
Border relations between Canada and Mexico have never been better.
- G. W. Bush


