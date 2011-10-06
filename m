Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab1JFSM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:12:27 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48439 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290Ab1JFSMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:12:25 -0400
X-Sasl-enc: keEguJ/fOAH8RdI1bzo69hXMMiN+SPFNRPbqK2ikpsxw 1317924744
Date: Thu, 6 Oct 2011 15:12:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?iso-8859-1?Q?Keng-Y=FC?= Lin <kengyu@canonical.com>
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: disable alsa volume
 mixer for SL410/SL510
Message-ID: <20111006181220.GA15950@khazad-dum.debian.net>
References: <1300181106-20219-1-git-send-email-keng-yu.lin@canonical.com>
 <20110316185755.GC7918@khazad-dum.debian.net>
 <CADXHx7b36g1+vo9cjuiq7VnjN3LWiwQtgepHjGU1P74ZsdtwQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADXHx7b36g1+vo9cjuiq7VnjN3LWiwQtgepHjGU1P74ZsdtwQw@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Oct 2011, Keng-Yü Lin wrote:
> On Thu, Mar 17, 2011 at 2:57 AM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > On Tue, 15 Mar 2011, Keng-Yu Lin wrote:
> >> The mute key on SL410/SL510 only works when the alsa volume mixer
> >> is not enabled. This patch makes the alsa volume mixer disabled
> >> on the matched SL410/SL510 EC versions.
> >
> > I'd like more data on this.  Is this some sort of weird interaction with
> > userspace, or does the firmware actually changes behaviour when we
> > enable the MUTE HKEY event in the event mask?
> 
> The firmware does not change its behaviour with the key enabled in the keymask.
> The mute key (and the LED on it) of the two models works good without
> thinkpad_acpi loaded. So in the patch I like to exclude the volume
> control part for the two models.

If the firmware does not change behaviour, doesn't that mean the bug is
elsewhere?

Is the firmware reporting these keys somewhere else (e.g. through the
keyboard)?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
