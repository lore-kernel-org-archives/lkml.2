Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031313Ab2K3RMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:12:13 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34995 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543Ab2K3RMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:12:10 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 30/32] staging: wlags49_h2: wl_util: fixes spacing around parentheses
Date: Fri, 30 Nov 2012 18:58:55 +0200
Message-Id: <1354294737-5735-30-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit corrects the spacing in an and around parentheses in the
file.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_util.h |   36 +++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_util.h b/drivers/staging/wlags49_h2/wl_util.h
index 946b1b6..67ee069 100644
--- a/drivers/staging/wlags49_h2/wl_util.h
+++ b/drivers/staging/wlags49_h2/wl_util.h
@@ -65,32 +65,32 @@
 /*******************************************************************************
  *  function prototypes
  ******************************************************************************/
-int dbm( int value );
+int dbm(int value);
 
-int is_valid_key_string( char *s );
+int is_valid_key_string(char *s);
 
-void key_string2key( char *ks, KEY_STRCT *key );
+void key_string2key(char *ks, KEY_STRCT *key);
 
-void wl_hcf_error( struct net_device *dev, int hcfStatus );
+void wl_hcf_error(struct net_device *dev, int hcfStatus);
 
-void wl_endian_translate_event( ltv_t *pLtv );
+void wl_endian_translate_event(ltv_t *pLtv);
 
-int wl_has_wep( IFBP ifbp );
+int wl_has_wep(IFBP ifbp);
 
-hcf_8   wl_parse_ds_ie( PROBE_RESP *probe_rsp );
-hcf_8 * wl_parse_wpa_ie( PROBE_RESP *probe_rsp, hcf_16 *length );
-hcf_8 * wl_print_wpa_ie( hcf_8 *buffer, int length );
+hcf_8   wl_parse_ds_ie(PROBE_RESP *probe_rsp);
+hcf_8 * wl_parse_wpa_ie(PROBE_RESP *probe_rsp, hcf_16 *length);
+hcf_8 * wl_print_wpa_ie(hcf_8 *buffer, int length);
 
 int wl_get_tallies(struct wl_private *, CFG_HERMES_TALLIES_STRCT *);
-int wl_is_a_valid_chan( int channel );
-int wl_is_a_valid_freq( long frequency );
-long wl_get_freq_from_chan( int channel );
-int wl_get_chan_from_freq( long frequency );
+int wl_is_a_valid_chan(int channel);
+int wl_is_a_valid_freq(long frequency);
+long wl_get_freq_from_chan(int channel);
+int wl_get_chan_from_freq(long frequency);
 
-void wl_process_link_status( struct wl_private *lp );
-void wl_process_probe_response( struct wl_private *lp );
-void wl_process_updated_record( struct wl_private *lp );
-void wl_process_assoc_status( struct wl_private *lp );
-void wl_process_security_status( struct wl_private *lp );
+void wl_process_link_status(struct wl_private *lp);
+void wl_process_probe_response(struct wl_private *lp);
+void wl_process_updated_record(struct wl_private *lp);
+void wl_process_assoc_status(struct wl_private *lp);
+void wl_process_security_status(struct wl_private *lp);
 
 #endif  // __WL_UTIL_H__
-- 
1.7.10.4

