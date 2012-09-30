Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab2I3JlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 05:41:12 -0400
Received: from ozy.pierre-beck.de ([178.63.78.113]:50877 "EHLO
	ozy.pierre-beck.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2I3JlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 05:41:08 -0400
Message-ID: <50680F21.1010103@pierre-beck.de>
From: Pierre Beck <mail@pierre-beck.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] snd-hda-intel audio distortion in Linus' current tree
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Original-Recipients: linux-kernel@vger.kernel.org
X-Original-Date: Sun, 30 Sep 2012 11:21:37 +0200
Date: Sun, 30 Sep 2012 11:22:04 +0200
X-Spam-Notice: Unscanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to confirm this bug exists in 3.6-rc7 32-bit. It seems to occur 
only when opening the audio output, and not with every audio player. MP3 
/ Ogg playback with VLC via Pulseaudio triggers the noise. Xine, Totem 
don't. After about 20 to 40 seconds, it suddenly disappears.

Greetings,

Pierre Beck
