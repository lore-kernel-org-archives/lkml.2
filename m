Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab1CZAMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:12:40 -0400
Received: from kroah.org ([198.145.64.141]:35843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933254Ab1CZAGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:56 2011
Message-Id: <20110326000456.873263491@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:03:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lydia Wang <lydiawang@viatech.com.cn>, Takashi Iwai <tiwai@suse.de>
Subject: [10/35] ALSA: hda - VIA: Add missing support for VT1718S in A-A path
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Lydia Wang <lydiawang@viatech.com.cn>

commit ab657e0cacc39d88145871c6a3c844597c02d406 upstream.

Modify mute_aa_path() function to support VT1718S codec.

Signed-off-by: Lydia Wang <lydiawang@viatech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_via.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1265,6 +1265,11 @@ static void mute_aa_path(struct hda_code
 		start_idx = 2;
 		end_idx = 4;
 		break;
+	case VT1718S:
+		nid_mixer = 0x21;
+		start_idx = 1;
+		end_idx = 3;
+		break;
 	default:
 		return;
 	}


