Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab2K3RGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:06:19 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57193 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851Ab2K3RGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:06:15 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 12:06:15 EST
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 07/32] staging: wlags49_h2: wl_enc: converts indentation spaces to tabs
Date: Fri, 30 Nov 2012 18:58:32 +0200
Message-Id: <1354294737-5735-7-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit converts space-based indentation to tabs.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_enc.c |  124 +++++++++++++++++------------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_enc.c b/drivers/staging/wlags49_h2/wl_enc.c
index 4c6f776..a62db46 100644
--- a/drivers/staging/wlags49_h2/wl_enc.c
+++ b/drivers/staging/wlags49_h2/wl_enc.c
@@ -107,55 +107,55 @@ extern dbg_info_t *DbgInfo;
  ******************************************************************************/
 int wl_wep_code( char *szCrypt, char *szDest, void *Data, int nLen )
 {
-    int     i;
-    int     t;
-    int     k ;
-    char    bits;
-    char    *szData = (char *) Data;
-    /*------------------------------------------------------------------------*/
+	int     i;
+	int     t;
+	int     k ;
+	char    bits;
+	char    *szData = (char *) Data;
+	/*------------------------------------------------------------------------*/
 
 
-    for( i = bits = 0 ; i < MACADDRESS_STR_LEN; i++ ) {
-	    bits ^= szCrypt[i];
-	    bits += szCrypt[i];
-    }
+	for( i = bits = 0 ; i < MACADDRESS_STR_LEN; i++ ) {
+		bits ^= szCrypt[i];
+		bits += szCrypt[i];
+	}
 
-    for( i = t = *szDest = 0; i < nLen; i++, t++ ) {
-	    k = szData[i] ^ ( bits + i );
+	for( i = t = *szDest = 0; i < nLen; i++, t++ ) {
+		k = szData[i] ^ ( bits + i );
 
 
-        switch( i % 3 ) {
+	switch( i % 3 ) {
 
-        case 0 :
+	case 0 :
 
-            szDest[t]   = ((k & 0xFC) >> 2) + CH_START ;
-			szDest[t+1] = ((k & 0x03) << 4) + CH_START ;
-	        szDest[t+2] = '\0';
+		szDest[t]   = ((k & 0xFC) >> 2) + CH_START ;
+		szDest[t+1] = ((k & 0x03) << 4) + CH_START ;
+		szDest[t+2] = '\0';
 
-            break;
+		break;
 
 
-        case 1 :
+	case 1 :
 
-            szDest[t]  += (( k & 0xF0 ) >> 4 );
-			szDest[t+1] = (( k & 0x0F ) << 2 ) + CH_START ;
-	        szDest[t+2] = '\0';
+		szDest[t]  += (( k & 0xF0 ) >> 4 );
+		szDest[t+1] = (( k & 0x0F ) << 2 ) + CH_START ;
+		szDest[t+2] = '\0';
 
-            break;
+		break;
 
 
-        case 2 :
+	case 2 :
 
-            szDest[t]  += (( k & 0xC0 ) >> 6 );
-			szDest[t+1] = ( k & 0x3F ) + CH_START ;
-	        szDest[t+2] = '\0';
-	        t++;
+		szDest[t]  += (( k & 0xC0 ) >> 6 );
+		szDest[t+1] = ( k & 0x3F ) + CH_START ;
+		szDest[t+2] = '\0';
+		t++;
 
-            break;
-        }
-    }
+		break;
+	}
+	}
 
-    return( strlen( szDest )) ;
+	return( strlen( szDest )) ;
 
 }
 /*============================================================================*/
@@ -184,48 +184,48 @@ int wl_wep_code( char *szCrypt, char *szDest, void *Data, int nLen )
  ******************************************************************************/
 int wl_wep_decode( char *szCrypt, void *Dest, char *szData )
 {
-    int     i;
-    int     t;
-    int     nLen;
-    char    bits;
-    char    *szDest = Dest;
-  /*------------------------------------------------------------------------*/
+	int     i;
+	int     t;
+	int     nLen;
+	char    bits;
+	char    *szDest = Dest;
+	/*------------------------------------------------------------------------*/
 
 
-  for( i = bits = 0 ; i < 12; i++ ) {
-      bits ^= szCrypt[i] ;
-      bits += szCrypt[i] ;
-  }
+	for( i = bits = 0 ; i < 12; i++ ) {
+		bits ^= szCrypt[i] ;
+		bits += szCrypt[i] ;
+	}
 
-  nLen = ( strlen( szData ) * 3) / 4 ;
+	nLen = ( strlen( szData ) * 3) / 4 ;
 
-  for( i = t = 0; i < nLen; i++, t++ ) {
-      switch( i % 3 ) {
-      case 0 :
+	for( i = t = 0; i < nLen; i++, t++ ) {
+		switch( i % 3 ) {
+		case 0 :
 
-          szDest[i] = ((( szData[t]-CH_START ) & 0x3f ) << 2 ) +
-                      ((( szData[t+1]-CH_START ) & 0x30 ) >> 4 );
-	      break;
+			szDest[i] = ((( szData[t]-CH_START ) & 0x3f ) << 2 ) +
+				    ((( szData[t+1]-CH_START ) & 0x30 ) >> 4 );
+			break;
 
 
-      case 1 :
-          szDest[i] = ((( szData[t]-CH_START ) & 0x0f ) << 4 ) +
-                      ((( szData[t+1]-CH_START ) & 0x3c ) >> 2 );
-	      break;
+		case 1 :
+			szDest[i] = ((( szData[t]-CH_START ) & 0x0f ) << 4 ) +
+				    ((( szData[t+1]-CH_START ) & 0x3c ) >> 2 );
+			break;
 
 
-      case 2 :
-          szDest[i] = ((( szData[t]-CH_START ) & 0x03 ) << 6 ) +
-                       (( szData[t+1]-CH_START ) & 0x3f );
-	      t++;
-	      break;
-      }
+		case 2 :
+			szDest[i] = ((( szData[t]-CH_START ) & 0x03 ) << 6 ) +
+				     (( szData[t+1]-CH_START ) & 0x3f );
+			t++;
+			break;
+		}
 
-	szDest[i] ^= ( bits + i ) ;
+		szDest[i] ^= ( bits + i ) ;
 
-  }
+	}
 
-  return( i ) ;
+	return( i ) ;
 
 }
 /*============================================================================*/
-- 
1.7.10.4

