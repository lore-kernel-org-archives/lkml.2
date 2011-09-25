Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1IYN3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 09:29:43 -0400
Received: from nm27-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.215]:44199 "HELO
	nm27-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752559Ab1IYN3l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 09:29:41 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Sep 2011 09:29:41 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 895205.97770.bm@omp1001.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=yjhy7iDv9Q36DF4ju66mNbV7Gi+nmQ4nR3vgKE0Ou3vHixgCvZu+TPwWu5wwCd+oJNjs+gNQW9AH6jqglF+A8gYoZw6xKKfPOkeLXgBgAJBWZ1h4HcX93ouMQmb9h3sLXD8WtLk9hPvS8lF6SU63NGYbFdTsAg9roLBdwXvYQoE=;
X-YMail-OSG: h1NSgqQVM1m_vmUKSeen3dsIeNGlppF7yhOMCMvWBbHTyQz
 CHe9Fr3vZr_QCs.1uZBhUG2UWHd7iQPInI2M0xCzx.UcL_9G7YaBAo17xMHo
 FuOiGllq0eQ_EIaCR9TRXtu5MmfHNFyhPjYHp_DH1hs589Z9SiD5w_QT7NLo
 HjjQ_FwceXPf4MH3aAgE8ZUUxx0mnejTa25zPIdTV4rqM51d3_S2FR9as5xg
 vg1Aj8Ey5swILvSzsnfc7KJ6y1THxs2sxm.gMMRJ_EtS._XR_1ZZMjOUope8
 4Uj7wlK1EIaCj6_RF2CBD1YdRLziSPkV_uf1j.xdrK.WN0WKneOqPEq_Aq.j
 B_cfR3owBZxeyofCgk4kqmo3W.1nKF7aurMtkP3YpHseNBoqKVd5ASqNgqwZ
 i.jc7_LdySFpHWD2NLZeret6bZ5V3v8oJTYyyG3cRjogODEb2IrakNjSbv1r
 4a55up4vLnQlNz7mIDYAhCOw2_DPFrhC5gzJRBKkRjgeJZoqY8vGNyFRGDfv
 r0hJSdst03zzf4m7SwTfoUtlPmcI-
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com> <yunvcsim1wk.fsf@aiko.keithp.com> <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com> <yunsjnln8it.fsf@aiko.keithp.com>
Message-ID: <1316957004.77729.YahooMailNeo@web130108.mail.mud.yahoo.com>
Date: Sun, 25 Sep 2011 06:23:24 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
To: Keith Packard <keithp@keithp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <yunsjnln8it.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Keith Packard <keithp@keithp.com>
>To: Alex Davis <alex14641@yahoo.com>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
>Cc:
>Sent: Saturday, September 24, 2011 1:40 PM
>Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
>
>On Sat, 24 Sep 2011 08:13:42 -0700 (PDT), Alex Davis <alex14641@yahoo.com> wrote:
>
>> One good thing about the 3.1 kernels is that I now have the /sys/class/backlight/intel_backlight directory
>> in addition to /sys/class/backlight/dell_backlight. With intel_backlight, I can control the LCD brightness;
>> dell_backlight never worked, neither in 3.0 or 3.1.
>
>Can you tell if the screen is blank with the backlight on, or is the
>screen drawn correctly and the backlight off?
>
>If the screen is blank but the backlight is on, then you may want a
>patch which is on my drm-intel-fixes branch.
>
>git://anongit.freedesktop.org/~keithp/linux
>
>If the screen is drawn, but the backlight is off, you may want to try
>reverting the native backlight patch:
>
>aaa6fd2a004147bf32fce05720938236de3361d9
>
>Author: Matthew Garrett <mjg@redhat.com>  2011-08-12 03:11:33
>Committer: Keith Packard <keithp@keithp.com>  2011-08-15 12:10:25
>Parent: 302983e9059e9ef5de3ca7671918eeb237c5971e (drm/i915/pch: Fix integer math bugs in panel fitting)
>
>Not all systems expose a firmware or platform mechanism for changing the backlight intensity on i915, so add native driver support.
>
>-- 
>keith.packard@intel.com

Action: close lid, open lid, and press return key.

Result with 3.0.x: password dialog appears. This is the correct result.

Result with git://anongit.freedesktop.org/~keithp/linux: screen is dark.
Manually adjusting the brightness reveals a functioning mouse cursor, but
no password dialog. Switching to a text console and back to the X session
reveals the dialog.

Result with 3.1rc7 with aaa6fd2a004147bf32fce05720938236de3361d9 reverted:
screen with a functioning mouse cursor, but no password dialog. Switching
to a text console and back to the X session reveals the dialog. Brightness
cannot be controlled.
