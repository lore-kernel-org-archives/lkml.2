Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866Ab2ERXRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:17:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38665 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946621Ab2ERXGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:06:03 -0400
Message-Id: <20120518212650.475234903@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Brian Austin <brian.austin@cirrus.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 14/47] ASoC: cs42l73: Sync digital mixer kcontrols to allow for 0dB
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Austin <brian.austin@cirrus.com>

commit 5807c3bf68eb489032ca8ff70b3d3c833fd8172b upstream.

Some of the Digital mixer kcontrol max values were off by 1 not allowing a max of 0dB.

Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/cs42l73.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/sound/soc/codecs/cs42l73.c
+++ b/sound/soc/codecs/cs42l73.c
@@ -568,22 +568,22 @@ static const struct snd_kcontrol_new cs4
 			attn_tlv),
 
 	SOC_SINGLE_TLV("SPK-IP Mono Volume",
-			CS42L73_SPKMIPMA, 0, 0x3E, 1, attn_tlv),
+			CS42L73_SPKMIPMA, 0, 0x3F, 1, attn_tlv),
 	SOC_SINGLE_TLV("SPK-XSP Mono Volume",
-			CS42L73_SPKMXSPA, 0, 0x3E, 1, attn_tlv),
+			CS42L73_SPKMXSPA, 0, 0x3F, 1, attn_tlv),
 	SOC_SINGLE_TLV("SPK-ASP Mono Volume",
-			CS42L73_SPKMASPA, 0, 0x3E, 1, attn_tlv),
+			CS42L73_SPKMASPA, 0, 0x3F, 1, attn_tlv),
 	SOC_SINGLE_TLV("SPK-VSP Mono Volume",
-			CS42L73_SPKMVSPMA, 0, 0x3E, 1, attn_tlv),
+			CS42L73_SPKMVSPMA, 0, 0x3F, 1, attn_tlv),
 
 	SOC_SINGLE_TLV("ESL-IP Mono Volume",
-			CS42L73_ESLMIPMA, 0, 0x3E, 1, attn_tlv),
+			CS42L73_ESLMIPMA, 0, 0x3F, 1, attn_tlv),
 	SOC_SINGLE_TLV("ESL-XSP Mono Volume",
-			CS42L73_ESLMXSPA, 0, 0x3E, 1, attn_tlv),
+			CS42L73_ESLMXSPA, 0, 0x3F, 1, attn_tlv),
 	SOC_SINGLE_TLV("ESL-ASP Mono Volume",
-			CS42L73_ESLMASPA, 0, 0x3E, 1, attn_tlv),
+			CS42L73_ESLMASPA, 0, 0x3F, 1, attn_tlv),
 	SOC_SINGLE_TLV("ESL-VSP Mono Volume",
-			CS42L73_ESLMVSPMA, 0, 0x3E, 1, attn_tlv),
+			CS42L73_ESLMVSPMA, 0, 0x3F, 1, attn_tlv),
 
 	SOC_ENUM("IP Digital Swap/Mono Select", ip_swap_enum),
 


