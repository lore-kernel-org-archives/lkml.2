Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1JSVZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:25:08 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:41295 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1JSVZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:25:06 -0400
Date: Wed, 19 Oct 2011 23:25:02 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keyboard and mouse issues on MacBook Air (4,2)
Message-ID: <20111019212502.GB2432@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20111017175906.GA3461@schottelius.org>
 <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz>
 <20111017214050.GA1408@schottelius.org>
 <20111019150122.GA6157@schottelius.org>
 <alpine.LNX.2.00.1110191702470.3541@pobox.suse.cz>
 <20111019210742.GA2432@schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20111019210742.GA2432@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc6-g4c437d5 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

+ xev attachement.

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=xev-patched

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x0, time 1356328, (157,521), root:(1121,541),
    state 0x0, keycode 232 (keysym 0x1008ff03, XF86MonBrightnessDown), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x0, time 1356440, (157,521), root:(1121,541),
    state 0x0, keycode 232 (keysym 0x1008ff03, XF86MonBrightnessDown), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x0, time 1358600, (157,521), root:(1121,541),
    state 0x0, keycode 233 (keysym 0x1008ff02, XF86MonBrightnessUp), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x0, time 1358704, (157,521), root:(1121,541),
    state 0x0, keycode 233 (keysym 0x1008ff02, XF86MonBrightnessUp), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x0, time 1359352, (157,521), root:(1121,541),
    state 0x0, keycode 128 (keysym 0x1008ff4a, XF86LaunchA), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x0, time 1359464, (157,521), root:(1121,541),
    state 0x0, keycode 128 (keysym 0x1008ff4a, XF86LaunchA), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x0, time 1359912, (157,521), root:(1121,541),
    state 0x0, keycode 212 (keysym 0x1008ff4b, XF86LaunchB), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

CreateNotify event, serial 27, synthetic NO, window 0xa00001,
    parent 0xa00001, window 0x400045, (157,521), width 1, height 1
border_width 0, override YES

MapNotify event, serial 27, synthetic NO, window 0xa00001,
    event 0xa00001, window 0x400045, override YES

LeaveNotify event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x0, time 1359967, (157,521), root:(1121,541),
    mode NotifyNormal, detail NotifyInferior, same_screen YES,
    focus YES, state 0

EnterNotify event, serial 27, synthetic YES, window 0xa00001,
    root 0xac, subw 0x0, time 0, (157,521), root:(1121,541),
    mode NotifyNormal, detail NotifyAncestor, same_screen YES,
    focus YES, state 0

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1360040, (157,521), root:(1121,541),
    state 0x0, keycode 212 (keysym 0x1008ff4b, XF86LaunchB), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1360568, (157,521), root:(1121,541),
    state 0x0, keycode 237 (keysym 0x1008ff06, XF86KbdBrightnessDown), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1360656, (157,521), root:(1121,541),
    state 0x0, keycode 237 (keysym 0x1008ff06, XF86KbdBrightnessDown), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1361112, (157,521), root:(1121,541),
    state 0x0, keycode 238 (keysym 0x1008ff05, XF86KbdBrightnessUp), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1361208, (157,521), root:(1121,541),
    state 0x0, keycode 238 (keysym 0x1008ff05, XF86KbdBrightnessUp), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1361608, (157,521), root:(1121,541),
    state 0x0, keycode 173 (keysym 0x1008ff16, XF86AudioPrev), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1361720, (157,521), root:(1121,541),
    state 0x0, keycode 173 (keysym 0x1008ff16, XF86AudioPrev), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1362104, (157,521), root:(1121,541),
    state 0x0, keycode 172 (keysym 0x1008ff14, XF86AudioPlay), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1362208, (157,521), root:(1121,541),
    state 0x0, keycode 172 (keysym 0x1008ff14, XF86AudioPlay), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1362608, (157,521), root:(1121,541),
    state 0x0, keycode 171 (keysym 0x1008ff17, XF86AudioNext), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1362712, (157,521), root:(1121,541),
    state 0x0, keycode 171 (keysym 0x1008ff17, XF86AudioNext), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1363080, (157,521), root:(1121,541),
    state 0x0, keycode 121 (keysym 0x1008ff12, XF86AudioMute), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1363208, (157,521), root:(1121,541),
    state 0x0, keycode 121 (keysym 0x1008ff12, XF86AudioMute), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1363776, (157,521), root:(1121,541),
    state 0x0, keycode 122 (keysym 0x1008ff11, XF86AudioLowerVolume), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1363864, (157,521), root:(1121,541),
    state 0x0, keycode 122 (keysym 0x1008ff11, XF86AudioLowerVolume), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyPress event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1364864, (157,521), root:(1121,541),
    state 0x0, keycode 123 (keysym 0x1008ff13, XF86AudioRaiseVolume), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 27, synthetic NO, window 0xa00001,
    root 0xac, subw 0x400045, time 1364968, (157,521), root:(1121,541),
    state 0x0, keycode 123 (keysym 0x1008ff13, XF86AudioRaiseVolume), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

--ew6BAiZeqk4r7MaW--
