Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2EBWJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:09:12 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39370 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751992Ab2EBWJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:09:11 -0400
Message-ID: <4FA1B082.1090205@mymail.coop>
Date: Wed, 02 May 2012 18:09:06 -0400
From: Bob Lightfoot <boblfoot@mymail.coop>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120425 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Hauppage HVR1600 - CX18 Issue with Centos 6.2 - Analog Sound comes
 and goes - MORE DATA
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well I've been reading the mailing lists and found that when I have a
Mythtv Capture running and check out performance I get the following:

[root@mythbox bob]# v4l2-ctl -d 2 --log-status | grep 843
   cx18-0 843: Video signal:              present
   cx18-0 843: Detected format:           NTSC-M
   cx18-0 843: Specified standard:        NTSC-M
   cx18-0 843: Specified video input:     Composite 7
   cx18-0 843: Specified audioclock freq: 48000 Hz
   cx18-0 843: Detected audio mode:       mono
   cx18-0 843: Detected audio standard:   no detected audio standard
   cx18-0 843: Audio muted:               yes
   cx18-0 843: Audio microcontroller:     running
   cx18-0 843: Configured audio standard: automatic detection
   cx18-0 843: Configured audio system:   BTSC
   cx18-0 843: Specified audio input:     Tuner (In8)
   cx18-0 843: Preferred audio mode:      stereo
[root@mythbox bob]#


If I was compiling from source there appears to be a way to force
fallback.  How this is done from the modprobe level on a package managed
system I have yet to figure out.

Bob Lightfoot
