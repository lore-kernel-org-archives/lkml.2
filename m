Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab2JWRHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:07:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36403 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab2JWRHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:07:14 -0400
Message-ID: <5086CEAC.2000804@gmail.com>
Date: Tue, 23 Oct 2012 10:06:52 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU
 hung
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is happening both with MAINLINE and NEXT.

basically system is running fine, then under load system becomes really 
sluggish and unresponsive. I was able to get dmesg of the error..:

[ 7745.007008] ath9k 0000:05:00.0 wlan0: disabling VHT as WMM/QoS is not 
supported by the AP
[ 7745.007736] wlan0: associate with 68:7f:74:b8:05:82 (try 1/3)
[ 7745.011456] wlan0: RX AssocResp from 68:7f:74:b8:05:82 (capab=0x411 
status=0 aid=5)
[ 7745.011529] wlan0: associated
[ 8120.812482] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer 
elapsed... GPU hung
[ 8120.812642] [drm] capturing error event; look for more information in 
/debug/dri/0/i915_error_state
[ 8122.328682] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer 
elapsed... GPU hung
[ 8122.328845] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring 
wedged!
[ 8122.328850] [drm:i915_reset] *ERROR* Failed to reset chip.

full log is here: http://fpaste.org/7xH8/

as for good kernels from what I remember 3.6.0-rc1. I can try a bisect 
on this once I get the time. or if anybody has a patch I can test.

Justin P. Mattock
