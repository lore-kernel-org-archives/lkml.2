Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab2LCRjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:39:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54711 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2LCRjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:39:54 -0500
Date: Mon, 3 Dec 2012 18:39:51 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: i915 freakout with latest 3.7 git
Message-ID: <20121203173951.GA25384@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+67 (d414971f0c48) (2011-07-01)
X-Provags-ID: V02:K0:xcQ58h9P5CX50WB8PZbXiPyZgn1P7YFVvyJ5/lrrdKE
 4y5u82Ev34Y4Vq1GZC+iB9pTD+KwJUDnN1OaLo4zG5avdlfeoA
 F8+ijSJFSTZI3Arcw7LUapJ3cl8kGAGda4OGD4v0F43gmtr2Rl
 bWQp+PIm+u2UCn2nbvE+XezVuLGTaEJ35TlQdEpPNHnNEWCBKp
 pIBOa+I6XeKr8UuoYnyp4ohbTxboPBDy3REWZI7JxAAeTDsqd0
 gj22USUNEbyV+YDJeExbl7BiCnvV10qo2C7B04Cdw6PPfcnmZ4
 L69BNWBWm2Tdb6bkaHHFAiOE4eld3cyphP+CTBnH5ncN8yjoJW
 fn8w9N0NagMICXtgZPA5VIJHpOxsoC+b/qRcgVpYU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with latest linus-3.7 git from today, after some time, my machine gets
more and more unresponsible, fanspeed increases, and that's what I see in the logs:

Dec  3 18:08:10 wildsau kernel: [35092.535757] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
Dec  3 18:08:10 wildsau kernel: [35092.535768] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
Dec  3 18:08:12 wildsau kernel: [35094.050918] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
Dec  3 18:08:12 wildsau kernel: [35094.051081] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
Dec  3 18:08:12 wildsau kernel: [35094.051086] [drm:i915_reset] *ERROR* Failed to reset chip.

I have never seen that before, up to 3.6.7.

Don't know what information would be important for you, but will
provide anything you'll ask me to.

Thanks,
Heinz.
