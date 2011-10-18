Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab1JRQBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:01:36 -0400
Received: from lo.gmane.org ([80.91.229.12]:40870 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932751Ab1JRQBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:01:35 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: n00bsys0p <n00b@n00bsys0p.co.uk>
Subject: Possible bug in via-velocity on 3.0+
Date: Tue, 18 Oct 2011 17:01:19 +0100
Message-ID: <j7k7sf$vbf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 81-86-39-215.dsl.pipex.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been trying to get a custom 3.0 kernel to boot via PXE on a VIA 
EPIA EN15000G, and have run into a problem where once the thin client 
starts to load the kernel, the entire screen turns into a mosaic of 
random colours and characters.

I've tested this serving a 2.6.35.8 kernel (configured identically to 
the 3.0) to the thin client where the master and client are both fitted 
with EPIA EN1500G, and it works perfectly. Also, I tried swapping the 
master's motherboard to a Gigabyte GA-D525TUD (Realtek LAN chip), and it 
succeeded in serving the 3.0 kernel to an EN15000G without a fault.

In all test cases, the master was using a 3.0 kernel.

Through this testing, I surmise that it is something to do with the LAN 
driver which is used, as this is the only thing I can see to have 
changed between the two running systems. Could it be accidentally 
overwriting the video RAM or something along those lines?

Here's a link to a photo of what the screen looks like when it goes 
wrong: 
https://lh3.googleusercontent.com/-sXFP41oaF9U/TpyMFg89CqI/AAAAAAAAA-I/PBrltIm0cB4/s720/PXEFail.jpg

Anyway, hope there's someone here who knows what might be happening here!

Alex

