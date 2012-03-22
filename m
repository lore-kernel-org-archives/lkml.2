Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031503Ab2CVXVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 19:21:12 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19442 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2CVXVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 19:21:08 -0400
Date: Fri, 23 Mar 2012 00:21:06 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <gregkh@linuxfoundation.org>
cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ed Okerson <eokerson@quicknet.net>,
        Greg Herlein <gherlein@quicknet.net>,
        "David W. Erhart" <derhart@quicknet.net>,
        John Sellers <jsellers@quicknet.net>,
        Mike Preston <mpreston@quicknet.net>,
        David Huggins-Daines <dhd@cepstral.com>,
        Fabio Ferrari <fabio.ferrari@digitro.com.br>,
        Artis Kugevics <artis@mt.lv>, Daniele Bellucci <bellucda@tiscali.it>
Subject: And patch 2 as well - Re: [PATCH 1/2] drivers/telephony/ixj.c::add_caps():
 don't rely on undefined behaviour
In-Reply-To: <20120320135143.GA4535@kroah.com>
Message-ID: <alpine.LNX.2.00.1203230019110.2935@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1203192332420.9012@swampdragon.chaosbits.net> <1332197078.7847.1.camel@joe2Laptop> <alpine.LNX.2.00.1203192345020.9012@swampdragon.chaosbits.net> <1332198657.7847.7.camel@joe2Laptop> <alpine.LNX.2.00.1203200017100.9012@swampdragon.chaosbits.net>
 <1332199784.7847.12.camel@joe2Laptop> <alpine.LNX.2.00.1203200034040.9012@swampdragon.chaosbits.net> <20120320135143.GA4535@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> Then care to send me the patch, against the linux-next tree, so I can
> queue it up for the 3.5 merge window?
> 
Here's patch [2/2] against linux-next


>From bf43136bbb39c2ff1bf170715e42b67096a617b6 Mon Sep 17 00:00:00 2001
From: Jesper Juhl <jj@chaosbits.net>
Date: Thu, 22 Mar 2012 17:56:23 +0100
Subject: [PATCH 2/2] drivers/staging/telephony/ixj.c: delete trailing whitespace

There's a lot of trailing whitespace in drivers/telephony/ixj.c .
This patch removes it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/telephony/ixj.c |  228 +++++++++++++++++++--------------------
 1 file changed, 114 insertions(+), 114 deletions(-)

diff --git a/drivers/staging/telephony/ixj.c b/drivers/staging/telephony/ixj.c
index f960279..fd7757a 100644
--- a/drivers/staging/telephony/ixj.c
+++ b/drivers/staging/telephony/ixj.c
@@ -19,20 +19,20 @@
  *                  David W. Erhart, <derhart@quicknet.net>
  *                  John Sellers, <jsellers@quicknet.net>
  *                  Mike Preston, <mpreston@quicknet.net>
- *    
+ *
  * Fixes:           David Huggins-Daines, <dhd@cepstral.com>
  *                  Fabio Ferrari, <fabio.ferrari@digitro.com.br>
  *                  Artis Kugevics, <artis@mt.lv>
  *                  Daniele Bellucci, <bellucda@tiscali.it>
  *
- * More information about the hardware related to this driver can be found  
+ * More information about the hardware related to this driver can be found
  * at our website:    http://www.quicknet.net
  *
  * IN NO EVENT SHALL QUICKNET TECHNOLOGIES, INC. BE LIABLE TO ANY PARTY FOR
  * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
  * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF QUICKNET
  * TECHNOLOGIES, INC. HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *    
+ *
  * QUICKNET TECHNOLOGIES, INC. SPECIFICALLY DISCLAIMS ANY WARRANTIES,
  * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
  * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
@@ -317,7 +317,7 @@ static IXJ *ixj[IXJMAX];
 /*
  *	Allocate a free IXJ device
  */
- 
+
 static IXJ *ixj_alloc()
 {
 	for(cnt=0; cnt<IXJMAX; cnt++)
@@ -366,7 +366,7 @@ static IXJ ixj[IXJMAX];
 /*
  *	Allocate a free IXJ device
  */
- 
+
 static IXJ *ixj_alloc(void)
 {
 	int cnt;
@@ -1084,7 +1084,7 @@ static void ixj_pstn_state(IXJ *j)
 							printk(KERN_INFO "IXJ /dev/phone%d Next Ring Cadence state at %u min %ld - %ld - max %ld\n", j->board,
 						j->cadence_f[4].on3, j->cadence_f[4].on3min, j->cadence_f[4].on3dot, j->cadence_f[4].on3max);
 							break;
-						case 6:	
+						case 6:
 							printk(KERN_INFO "IXJ /dev/phone%d Next Ring Cadence state at %u min %ld - %ld - max %ld\n", j->board,
 						j->cadence_f[4].off3, j->cadence_f[4].off3min, j->cadence_f[4].off3dot, j->cadence_f[4].off3max);
 							break;
@@ -1109,7 +1109,7 @@ static void ixj_pstn_state(IXJ *j)
 				}
 				j->pstn_ring_stop = j->pstn_ring_int = 0;
 				daa_set_mode(j, SOP_PU_SLEEP);
-			} 
+			}
 			outb_p(j->pld_scrw.byte, j->XILINXbase);
 			if (j->pstn_cid_intr && time_after(jiffies, j->pstn_cid_received + hertz)) {
 				ixj_daa_cid_read(j);
@@ -1133,7 +1133,7 @@ static void ixj_pstn_state(IXJ *j)
 							printk("IXJ DAA possible wink /dev/phone%d %ld\n", j->board, jiffies);
 						}
 						j->pstn_winkstart = jiffies;
-					} 
+					}
 				} else {
 					if (j->pstn_winkstart) {
 						if(ixjdebug & 0x0008) {
@@ -1524,7 +1524,7 @@ static inline void LED_SetState(int state, IXJ *j)
 /*********************************************************************
 *  GPIO Pins are configured as follows on the Quicknet Internet
 *  PhoneJACK Telephony Cards
-* 
+*
 * POTS Select        GPIO_6=0 GPIO_7=0
 * Mic/Speaker Select GPIO_6=0 GPIO_7=1
 * Handset Select     GPIO_6=1 GPIO_7=0
@@ -1932,7 +1932,7 @@ static int ixj_hookstate(IXJ *j)
 			if(fOffHook != j->p_hook) {
 				if(!j->checkwait) {
 					j->checkwait = jiffies;
-				} 
+				}
 				if(time_before(jiffies, j->checkwait + 2)) {
 					fOffHook ^= 1;
 				} else {
@@ -2342,8 +2342,8 @@ static int ixj_release(struct inode *inode, struct file *file_p)
 		j->ixj_signals[cnt] = SIGIO;
 
 	/* Set the excetion signal enable flags */
-	j->ex_sig.bits.dtmf_ready = j->ex_sig.bits.hookstate = j->ex_sig.bits.flash = j->ex_sig.bits.pstn_ring = 
-	j->ex_sig.bits.caller_id = j->ex_sig.bits.pstn_wink = j->ex_sig.bits.f0 = j->ex_sig.bits.f1 = j->ex_sig.bits.f2 = 
+	j->ex_sig.bits.dtmf_ready = j->ex_sig.bits.hookstate = j->ex_sig.bits.flash = j->ex_sig.bits.pstn_ring =
+	j->ex_sig.bits.caller_id = j->ex_sig.bits.pstn_wink = j->ex_sig.bits.f0 = j->ex_sig.bits.f1 = j->ex_sig.bits.f2 =
 	j->ex_sig.bits.f3 = j->ex_sig.bits.fc0 = j->ex_sig.bits.fc1 = j->ex_sig.bits.fc2 = j->ex_sig.bits.fc3 = 1;
 
 	file_p->private_data = NULL;
@@ -2506,7 +2506,7 @@ static int read_filters(IXJ *j)
 					j->cadence_f[cnt].on1, j->cadence_f[cnt].on1min, j->cadence_f[cnt].on1dot, j->cadence_f[cnt].on1max);
 						break;
 					case 2:
-						printk(KERN_INFO "IXJ /dev/phone%d Next Tone Cadence state at %ld - %ld\n", j->board, j->cadence_f[cnt].off1min, 
+						printk(KERN_INFO "IXJ /dev/phone%d Next Tone Cadence state at %ld - %ld\n", j->board, j->cadence_f[cnt].off1min,
 															j->cadence_f[cnt].off1max);
 						break;
 					case 3:
@@ -2521,12 +2521,12 @@ static int read_filters(IXJ *j)
 						printk(KERN_INFO "IXJ /dev/phone%d Next Tone Cadence state at %ld - %ld\n", j->board, j->cadence_f[cnt].on3min,
 															j->cadence_f[cnt].on3max);
 						break;
-					case 6:	
+					case 6:
 						printk(KERN_INFO "IXJ /dev/phone%d Next Tone Cadence state at %ld - %ld\n", j->board, j->cadence_f[cnt].off3min,
 															j->cadence_f[cnt].off3max);
 						break;
 				}
-			} 
+			}
 		}
 		if (j->cadence_f[cnt].state == 7) {
 			j->cadence_f[cnt].state = 0;
@@ -2656,37 +2656,37 @@ static void ulaw2alaw(unsigned char *buff, unsigned long len)
 {
 	static unsigned char table_ulaw2alaw[] =
 	{
-		0x2A, 0x2B, 0x28, 0x29, 0x2E, 0x2F, 0x2C, 0x2D, 
-		0x22, 0x23, 0x20, 0x21, 0x26, 0x27, 0x24, 0x25, 
-		0x3A, 0x3B, 0x38, 0x39, 0x3E, 0x3F, 0x3C, 0x3D, 
-		0x32, 0x33, 0x30, 0x31, 0x36, 0x37, 0x34, 0x35, 
-		0x0B, 0x08, 0x09, 0x0E, 0x0F, 0x0C, 0x0D, 0x02, 
-		0x03, 0x00, 0x01, 0x06, 0x07, 0x04, 0x05, 0x1A, 
-		0x1B, 0x18, 0x19, 0x1E, 0x1F, 0x1C, 0x1D, 0x12, 
-		0x13, 0x10, 0x11, 0x16, 0x17, 0x14, 0x15, 0x6B, 
-		0x68, 0x69, 0x6E, 0x6F, 0x6C, 0x6D, 0x62, 0x63, 
-		0x60, 0x61, 0x66, 0x67, 0x64, 0x65, 0x7B, 0x79, 
-		0x7E, 0x7F, 0x7C, 0x7D, 0x72, 0x73, 0x70, 0x71, 
-		0x76, 0x77, 0x74, 0x75, 0x4B, 0x49, 0x4F, 0x4D, 
-		0x42, 0x43, 0x40, 0x41, 0x46, 0x47, 0x44, 0x45, 
-		0x5A, 0x5B, 0x58, 0x59, 0x5E, 0x5F, 0x5C, 0x5D, 
-		0x52, 0x52, 0x53, 0x53, 0x50, 0x50, 0x51, 0x51, 
-		0x56, 0x56, 0x57, 0x57, 0x54, 0x54, 0x55, 0xD5, 
-		0xAA, 0xAB, 0xA8, 0xA9, 0xAE, 0xAF, 0xAC, 0xAD, 
-		0xA2, 0xA3, 0xA0, 0xA1, 0xA6, 0xA7, 0xA4, 0xA5, 
-		0xBA, 0xBB, 0xB8, 0xB9, 0xBE, 0xBF, 0xBC, 0xBD, 
-		0xB2, 0xB3, 0xB0, 0xB1, 0xB6, 0xB7, 0xB4, 0xB5, 
-		0x8B, 0x88, 0x89, 0x8E, 0x8F, 0x8C, 0x8D, 0x82, 
-		0x83, 0x80, 0x81, 0x86, 0x87, 0x84, 0x85, 0x9A, 
-		0x9B, 0x98, 0x99, 0x9E, 0x9F, 0x9C, 0x9D, 0x92, 
-		0x93, 0x90, 0x91, 0x96, 0x97, 0x94, 0x95, 0xEB, 
-		0xE8, 0xE9, 0xEE, 0xEF, 0xEC, 0xED, 0xE2, 0xE3, 
-		0xE0, 0xE1, 0xE6, 0xE7, 0xE4, 0xE5, 0xFB, 0xF9, 
-		0xFE, 0xFF, 0xFC, 0xFD, 0xF2, 0xF3, 0xF0, 0xF1, 
-		0xF6, 0xF7, 0xF4, 0xF5, 0xCB, 0xC9, 0xCF, 0xCD, 
-		0xC2, 0xC3, 0xC0, 0xC1, 0xC6, 0xC7, 0xC4, 0xC5, 
-		0xDA, 0xDB, 0xD8, 0xD9, 0xDE, 0xDF, 0xDC, 0xDD, 
-		0xD2, 0xD2, 0xD3, 0xD3, 0xD0, 0xD0, 0xD1, 0xD1, 
+		0x2A, 0x2B, 0x28, 0x29, 0x2E, 0x2F, 0x2C, 0x2D,
+		0x22, 0x23, 0x20, 0x21, 0x26, 0x27, 0x24, 0x25,
+		0x3A, 0x3B, 0x38, 0x39, 0x3E, 0x3F, 0x3C, 0x3D,
+		0x32, 0x33, 0x30, 0x31, 0x36, 0x37, 0x34, 0x35,
+		0x0B, 0x08, 0x09, 0x0E, 0x0F, 0x0C, 0x0D, 0x02,
+		0x03, 0x00, 0x01, 0x06, 0x07, 0x04, 0x05, 0x1A,
+		0x1B, 0x18, 0x19, 0x1E, 0x1F, 0x1C, 0x1D, 0x12,
+		0x13, 0x10, 0x11, 0x16, 0x17, 0x14, 0x15, 0x6B,
+		0x68, 0x69, 0x6E, 0x6F, 0x6C, 0x6D, 0x62, 0x63,
+		0x60, 0x61, 0x66, 0x67, 0x64, 0x65, 0x7B, 0x79,
+		0x7E, 0x7F, 0x7C, 0x7D, 0x72, 0x73, 0x70, 0x71,
+		0x76, 0x77, 0x74, 0x75, 0x4B, 0x49, 0x4F, 0x4D,
+		0x42, 0x43, 0x40, 0x41, 0x46, 0x47, 0x44, 0x45,
+		0x5A, 0x5B, 0x58, 0x59, 0x5E, 0x5F, 0x5C, 0x5D,
+		0x52, 0x52, 0x53, 0x53, 0x50, 0x50, 0x51, 0x51,
+		0x56, 0x56, 0x57, 0x57, 0x54, 0x54, 0x55, 0xD5,
+		0xAA, 0xAB, 0xA8, 0xA9, 0xAE, 0xAF, 0xAC, 0xAD,
+		0xA2, 0xA3, 0xA0, 0xA1, 0xA6, 0xA7, 0xA4, 0xA5,
+		0xBA, 0xBB, 0xB8, 0xB9, 0xBE, 0xBF, 0xBC, 0xBD,
+		0xB2, 0xB3, 0xB0, 0xB1, 0xB6, 0xB7, 0xB4, 0xB5,
+		0x8B, 0x88, 0x89, 0x8E, 0x8F, 0x8C, 0x8D, 0x82,
+		0x83, 0x80, 0x81, 0x86, 0x87, 0x84, 0x85, 0x9A,
+		0x9B, 0x98, 0x99, 0x9E, 0x9F, 0x9C, 0x9D, 0x92,
+		0x93, 0x90, 0x91, 0x96, 0x97, 0x94, 0x95, 0xEB,
+		0xE8, 0xE9, 0xEE, 0xEF, 0xEC, 0xED, 0xE2, 0xE3,
+		0xE0, 0xE1, 0xE6, 0xE7, 0xE4, 0xE5, 0xFB, 0xF9,
+		0xFE, 0xFF, 0xFC, 0xFD, 0xF2, 0xF3, 0xF0, 0xF1,
+		0xF6, 0xF7, 0xF4, 0xF5, 0xCB, 0xC9, 0xCF, 0xCD,
+		0xC2, 0xC3, 0xC0, 0xC1, 0xC6, 0xC7, 0xC4, 0xC5,
+		0xDA, 0xDB, 0xD8, 0xD9, 0xDE, 0xDF, 0xDC, 0xDD,
+		0xD2, 0xD2, 0xD3, 0xD3, 0xD0, 0xD0, 0xD1, 0xD1,
 		0xD6, 0xD6, 0xD7, 0xD7, 0xD4, 0xD4, 0xD5, 0xD5
 	};
 
@@ -2701,37 +2701,37 @@ static void alaw2ulaw(unsigned char *buff, unsigned long len)
 {
 	static unsigned char table_alaw2ulaw[] =
 	{
-		0x29, 0x2A, 0x27, 0x28, 0x2D, 0x2E, 0x2B, 0x2C, 
-		0x21, 0x22, 0x1F, 0x20, 0x25, 0x26, 0x23, 0x24, 
-		0x39, 0x3A, 0x37, 0x38, 0x3D, 0x3E, 0x3B, 0x3C, 
-		0x31, 0x32, 0x2F, 0x30, 0x35, 0x36, 0x33, 0x34, 
-		0x0A, 0x0B, 0x08, 0x09, 0x0E, 0x0F, 0x0C, 0x0D, 
-		0x02, 0x03, 0x00, 0x01, 0x06, 0x07, 0x04, 0x05, 
-		0x1A, 0x1B, 0x18, 0x19, 0x1E, 0x1F, 0x1C, 0x1D, 
-		0x12, 0x13, 0x10, 0x11, 0x16, 0x17, 0x14, 0x15, 
-		0x62, 0x63, 0x60, 0x61, 0x66, 0x67, 0x64, 0x65, 
-		0x5D, 0x5D, 0x5C, 0x5C, 0x5F, 0x5F, 0x5E, 0x5E, 
-		0x74, 0x76, 0x70, 0x72, 0x7C, 0x7E, 0x78, 0x7A, 
-		0x6A, 0x6B, 0x68, 0x69, 0x6E, 0x6F, 0x6C, 0x6D, 
-		0x48, 0x49, 0x46, 0x47, 0x4C, 0x4D, 0x4A, 0x4B, 
-		0x40, 0x41, 0x3F, 0x3F, 0x44, 0x45, 0x42, 0x43, 
-		0x56, 0x57, 0x54, 0x55, 0x5A, 0x5B, 0x58, 0x59, 
-		0x4F, 0x4F, 0x4E, 0x4E, 0x52, 0x53, 0x50, 0x51, 
-		0xA9, 0xAA, 0xA7, 0xA8, 0xAD, 0xAE, 0xAB, 0xAC, 
-		0xA1, 0xA2, 0x9F, 0xA0, 0xA5, 0xA6, 0xA3, 0xA4, 
-		0xB9, 0xBA, 0xB7, 0xB8, 0xBD, 0xBE, 0xBB, 0xBC, 
-		0xB1, 0xB2, 0xAF, 0xB0, 0xB5, 0xB6, 0xB3, 0xB4, 
-		0x8A, 0x8B, 0x88, 0x89, 0x8E, 0x8F, 0x8C, 0x8D, 
-		0x82, 0x83, 0x80, 0x81, 0x86, 0x87, 0x84, 0x85, 
-		0x9A, 0x9B, 0x98, 0x99, 0x9E, 0x9F, 0x9C, 0x9D, 
-		0x92, 0x93, 0x90, 0x91, 0x96, 0x97, 0x94, 0x95, 
-		0xE2, 0xE3, 0xE0, 0xE1, 0xE6, 0xE7, 0xE4, 0xE5, 
-		0xDD, 0xDD, 0xDC, 0xDC, 0xDF, 0xDF, 0xDE, 0xDE, 
-		0xF4, 0xF6, 0xF0, 0xF2, 0xFC, 0xFE, 0xF8, 0xFA, 
-		0xEA, 0xEB, 0xE8, 0xE9, 0xEE, 0xEF, 0xEC, 0xED, 
-		0xC8, 0xC9, 0xC6, 0xC7, 0xCC, 0xCD, 0xCA, 0xCB, 
-		0xC0, 0xC1, 0xBF, 0xBF, 0xC4, 0xC5, 0xC2, 0xC3, 
-		0xD6, 0xD7, 0xD4, 0xD5, 0xDA, 0xDB, 0xD8, 0xD9, 
+		0x29, 0x2A, 0x27, 0x28, 0x2D, 0x2E, 0x2B, 0x2C,
+		0x21, 0x22, 0x1F, 0x20, 0x25, 0x26, 0x23, 0x24,
+		0x39, 0x3A, 0x37, 0x38, 0x3D, 0x3E, 0x3B, 0x3C,
+		0x31, 0x32, 0x2F, 0x30, 0x35, 0x36, 0x33, 0x34,
+		0x0A, 0x0B, 0x08, 0x09, 0x0E, 0x0F, 0x0C, 0x0D,
+		0x02, 0x03, 0x00, 0x01, 0x06, 0x07, 0x04, 0x05,
+		0x1A, 0x1B, 0x18, 0x19, 0x1E, 0x1F, 0x1C, 0x1D,
+		0x12, 0x13, 0x10, 0x11, 0x16, 0x17, 0x14, 0x15,
+		0x62, 0x63, 0x60, 0x61, 0x66, 0x67, 0x64, 0x65,
+		0x5D, 0x5D, 0x5C, 0x5C, 0x5F, 0x5F, 0x5E, 0x5E,
+		0x74, 0x76, 0x70, 0x72, 0x7C, 0x7E, 0x78, 0x7A,
+		0x6A, 0x6B, 0x68, 0x69, 0x6E, 0x6F, 0x6C, 0x6D,
+		0x48, 0x49, 0x46, 0x47, 0x4C, 0x4D, 0x4A, 0x4B,
+		0x40, 0x41, 0x3F, 0x3F, 0x44, 0x45, 0x42, 0x43,
+		0x56, 0x57, 0x54, 0x55, 0x5A, 0x5B, 0x58, 0x59,
+		0x4F, 0x4F, 0x4E, 0x4E, 0x52, 0x53, 0x50, 0x51,
+		0xA9, 0xAA, 0xA7, 0xA8, 0xAD, 0xAE, 0xAB, 0xAC,
+		0xA1, 0xA2, 0x9F, 0xA0, 0xA5, 0xA6, 0xA3, 0xA4,
+		0xB9, 0xBA, 0xB7, 0xB8, 0xBD, 0xBE, 0xBB, 0xBC,
+		0xB1, 0xB2, 0xAF, 0xB0, 0xB5, 0xB6, 0xB3, 0xB4,
+		0x8A, 0x8B, 0x88, 0x89, 0x8E, 0x8F, 0x8C, 0x8D,
+		0x82, 0x83, 0x80, 0x81, 0x86, 0x87, 0x84, 0x85,
+		0x9A, 0x9B, 0x98, 0x99, 0x9E, 0x9F, 0x9C, 0x9D,
+		0x92, 0x93, 0x90, 0x91, 0x96, 0x97, 0x94, 0x95,
+		0xE2, 0xE3, 0xE0, 0xE1, 0xE6, 0xE7, 0xE4, 0xE5,
+		0xDD, 0xDD, 0xDC, 0xDC, 0xDF, 0xDF, 0xDE, 0xDE,
+		0xF4, 0xF6, 0xF0, 0xF2, 0xFC, 0xFE, 0xF8, 0xFA,
+		0xEA, 0xEB, 0xE8, 0xE9, 0xEE, 0xEF, 0xEC, 0xED,
+		0xC8, 0xC9, 0xC6, 0xC7, 0xCC, 0xCD, 0xCA, 0xCB,
+		0xC0, 0xC1, 0xBF, 0xBF, 0xC4, 0xC5, 0xC2, 0xC3,
+		0xD6, 0xD7, 0xD4, 0xD5, 0xDA, 0xDB, 0xD8, 0xD9,
 		0xCF, 0xCF, 0xCE, 0xCE, 0xD2, 0xD3, 0xD0, 0xD1
 	};
 
@@ -3090,7 +3090,7 @@ static int ixj_write_cid_string(IXJ *j, char *s, int checksum)
 
 static void ixj_pad_fsk(IXJ *j, int pad)
 {
-	int cnt; 
+	int cnt;
 
 	for (cnt = 0; cnt < pad; cnt++) {
 		if(j->fskdcnt < (j->fsksize - 1))
@@ -3474,7 +3474,7 @@ static void ixj_write_frame(IXJ *j)
 			ixj_post_cid(j);
 		}
 		/* This may seem rude, but if we just played one frame of FSK data for CallerID
-		   and there is real audio data in the buffer, we need to throw it away because 
+		   and there is real audio data in the buffer, we need to throw it away because
 		   we just used it's time slot */
 		if (j->write_buffer_rp > j->write_buffer_wp) {
 			j->write_buffer_rp += j->cid_play_frame_size * 2;
@@ -3486,7 +3486,7 @@ static void ixj_write_frame(IXJ *j)
 
 			wake_up_interruptible(&j->poll_q);	/* Wake any blocked selects */
 		}
-	} else if (j->write_buffer && j->write_buffers_empty < 1) { 
+	} else if (j->write_buffer && j->write_buffers_empty < 1) {
 		if (j->write_buffer_wp > j->write_buffer_rp) {
 			frame_count =
 			    (j->write_buffer_wp - j->write_buffer_rp) / (j->play_frame_size * 2);
@@ -4150,7 +4150,7 @@ static void ixj_aec_start(IXJ *j, int level)
 
 			ixj_WriteDSPCommand(0xCF97, j);	/* Set AGC Enable */
 			ixj_WriteDSPCommand(0x0000, j);	/* to off */
-			
+
 			break;
 
 		case AEC_MED:
@@ -4161,7 +4161,7 @@ static void ixj_aec_start(IXJ *j, int level)
 
 			ixj_WriteDSPCommand(0xCF97, j);	/* Set AGC Enable */
 			ixj_WriteDSPCommand(0x0000, j);	/* to off */
-			
+
 			break;
 
 		case AEC_HIGH:
@@ -4172,7 +4172,7 @@ static void ixj_aec_start(IXJ *j, int level)
 
 			ixj_WriteDSPCommand(0xCF97, j);	/* Set AGC Enable */
 			ixj_WriteDSPCommand(0x0000, j);	/* to off */
-			
+
 			break;
 
 		case AEC_AGC:
@@ -4197,28 +4197,28 @@ static void ixj_aec_start(IXJ *j, int level)
 			/* Now we can set the AGC initial parameters and turn it on */
 			ixj_WriteDSPCommand(0xCF90, j);	/* Set AGC Minimum gain */
 			ixj_WriteDSPCommand(0x0020, j);	/* to 0.125 (-18dB) */
-	
+
 			ixj_WriteDSPCommand(0xCF91, j);	/* Set AGC Maximum gain */
 			ixj_WriteDSPCommand(0x1000, j);	/* to 16 (24dB) */
-			
+
 			ixj_WriteDSPCommand(0xCF92, j);	/* Set AGC start gain */
 			ixj_WriteDSPCommand(0x0800, j);	/* to 8 (+18dB) */
-		
+
 			ixj_WriteDSPCommand(0xCF93, j);	/* Set AGC hold time */
 			ixj_WriteDSPCommand(0x1F40, j);	/* to 2 seconds (units are 250us) */
-			
+
 			ixj_WriteDSPCommand(0xCF94, j);	/* Set AGC Attack Time Constant */
 			ixj_WriteDSPCommand(0x0005, j);	/* to 8ms */
-			
+
 			ixj_WriteDSPCommand(0xCF95, j);	/* Set AGC Decay Time Constant */
 			ixj_WriteDSPCommand(0x000D, j);	/* to 4096ms */
-			
+
 			ixj_WriteDSPCommand(0xCF96, j);	/* Set AGC Attack Threshold */
 			ixj_WriteDSPCommand(0x1200, j);	/* to 25% */
-			
+
 			ixj_WriteDSPCommand(0xCF97, j);	/* Set AGC Enable */
 			ixj_WriteDSPCommand(0x0001, j);	/* to on */
-			
+
 			break;
 
 		case AEC_AUTO:
@@ -4495,7 +4495,7 @@ static int ixj_play_start(IXJ *j)
 		return -ENOMEM;
 	}
 /*	j->write_buffers_empty = 2; */
-	j->write_buffers_empty = 1; 
+	j->write_buffers_empty = 1;
 	j->write_buffer_size = j->play_frame_size * 2;
 	j->write_buffer_end = j->write_buffer + j->play_frame_size * 2;
 	j->write_buffer_rp = j->write_buffer_wp = j->write_buffer;
@@ -6465,9 +6465,9 @@ static long do_ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long ar
 		ixj_ringback(j);
 		break;
 	case PHONE_WINK:
-		if(j->cardtype == QTI_PHONEJACK) 
+		if(j->cardtype == QTI_PHONEJACK)
 			retval = -1;
-		else 
+		else
 			retval = ixj_wink(j);
 		break;
 	case PHONE_CPT_STOP:
@@ -6553,7 +6553,7 @@ static long do_ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long ar
 		ixj_write_vmwi(j, arg);
 		break;
 	case IXJCTL_CID:
-		if (copy_to_user(argp, &j->cid, sizeof(PHONE_CID))) 
+		if (copy_to_user(argp, &j->cid, sizeof(PHONE_CID)))
 			retval = -EFAULT;
 		j->ex.bits.caller_id = 0;
 		break;
@@ -6575,13 +6575,13 @@ static long do_ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long ar
 		break;
 	case PHONE_CAPABILITIES_LIST:
 		add_caps(j);
-		if (copy_to_user(argp, j->caplist, sizeof(struct phone_capability) * j->caps)) 
+		if (copy_to_user(argp, j->caplist, sizeof(struct phone_capability) * j->caps))
 			retval = -EFAULT;
 		break;
 	case PHONE_CAPABILITIES_CHECK:
 		{
 			struct phone_capability cap;
-			if (copy_from_user(&cap, argp, sizeof(cap))) 
+			if (copy_from_user(&cap, argp, sizeof(cap)))
 				retval = -EFAULT;
 			else {
 				add_caps(j);
@@ -6597,13 +6597,13 @@ static long do_ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long ar
 		j->ex.bits.pstn_ring = 0;
 		break;
 	case IXJCTL_SET_FILTER:
-		if (copy_from_user(&jf, argp, sizeof(jf))) 
+		if (copy_from_user(&jf, argp, sizeof(jf)))
 			retval = -EFAULT;
 		else
 			retval = ixj_init_filter(j, &jf);
 		break;
 	case IXJCTL_SET_FILTER_RAW:
-		if (copy_from_user(&jfr, argp, sizeof(jfr))) 
+		if (copy_from_user(&jfr, argp, sizeof(jfr)))
 			retval = -EFAULT;
 		else
 			retval = ixj_init_filter_raw(j, &jfr);
@@ -6638,9 +6638,9 @@ static long do_ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long ar
 				raise *= 2;
 			}
 			if(j->sigdef.signal)
-				j->ex_sig.bytes |= raise; 
+				j->ex_sig.bytes |= raise;
 			else
-				j->ex_sig.bytes &= (raise^0xffff); 
+				j->ex_sig.bytes &= (raise^0xffff);
 		}
 		break;
 	case IXJCTL_INTERCOM_STOP:
@@ -7040,9 +7040,9 @@ static int ixj_selfprobe(IXJ *j)
 
 	/* initialise the DTMF prescale to a sensible value */
 	if (j->cardtype == QTI_LINEJACK) {
-		set_dtmf_prescale(j, 0x10); 
+		set_dtmf_prescale(j, 0x10);
 	} else {
-		set_dtmf_prescale(j, 0x40); 
+		set_dtmf_prescale(j, 0x40);
 	}
 	set_play_volume(j, 0x100);
 	set_rec_volume(j, 0x100);
@@ -7095,15 +7095,15 @@ static int ixj_selfprobe(IXJ *j)
 		j->ixj_signals[cnt] = SIGIO;
 
 	/* Set the excetion signal enable flags */
-	j->ex_sig.bits.dtmf_ready = j->ex_sig.bits.hookstate = j->ex_sig.bits.flash = j->ex_sig.bits.pstn_ring = 
-	j->ex_sig.bits.caller_id = j->ex_sig.bits.pstn_wink = j->ex_sig.bits.f0 = j->ex_sig.bits.f1 = j->ex_sig.bits.f2 = 
+	j->ex_sig.bits.dtmf_ready = j->ex_sig.bits.hookstate = j->ex_sig.bits.flash = j->ex_sig.bits.pstn_ring =
+	j->ex_sig.bits.caller_id = j->ex_sig.bits.pstn_wink = j->ex_sig.bits.f0 = j->ex_sig.bits.f1 = j->ex_sig.bits.f2 =
 	j->ex_sig.bits.f3 = j->ex_sig.bits.fc0 = j->ex_sig.bits.fc1 = j->ex_sig.bits.fc2 = j->ex_sig.bits.fc3 = 1;
 #ifdef IXJ_DYN_ALLOC
 	j->fskdata = NULL;
 #endif
 	j->fskdcnt = 0;
 	j->cidcw_wait = 0;
- 
+
 	/* Register with the Telephony for Linux subsystem */
 	j->p.f_op = &ixj_fops;
 	j->p.open = ixj_open;
@@ -7118,7 +7118,7 @@ static int ixj_selfprobe(IXJ *j)
 /*
  *	Exported service for pcmcia card handling
  */
- 
+
 IXJ *ixj_pcmcia_probe(unsigned long dsp, unsigned long xilinx)
 {
 	IXJ *j = ixj_alloc();
@@ -7320,7 +7320,7 @@ static int ixj_get_status_proc(char *buf)
 			len += sprintf(buf + len, "\nRec volume 0x%x", get_rec_volume(j));
 			len += sprintf(buf + len, "\nPlay volume 0x%x", get_play_volume(j));
 			len += sprintf(buf + len, "\nDTMF prescale 0x%x", get_dtmf_prescale(j));
-			
+
 			len += sprintf(buf + len, "\nHook state %d", j->hookstate); /* j->r_hook);	*/
 
 			if (j->cardtype == QTI_LINEJACK) {
@@ -7417,7 +7417,7 @@ static int ixj_get_status_proc(char *buf)
                         len += sprintf(buf + len, "\nPControl Wait Fails %ld", j->pcontrolwaitfail);
                         len += sprintf(buf + len, "\nIs Control Ready Checks %ld", j->iscontrolready);
                         len += sprintf(buf + len, "\nIs Control Ready Check failures %ld", j->iscontrolreadyfail);
- 
+
 #endif
 			len += sprintf(buf + len, "\n");
 		}
@@ -7608,7 +7608,7 @@ static IXJ *new_ixj(unsigned long port)
 }
 
 static int __init ixj_probe_isapnp(int *cnt)
-{               
+{
 	int probe = 0;
 	int func = 0x110;
         struct pnp_dev *dev = NULL, *old_dev = NULL;
@@ -7686,7 +7686,7 @@ static int __init ixj_probe_isapnp(int *cnt)
 	}
 	return probe;
 }
-                        
+
 static int __init ixj_probe_isa(int *cnt)
 {
 	int i, probe;
@@ -7713,7 +7713,7 @@ static int __init ixj_probe_isa(int *cnt)
 
 static int __init ixj_probe_pci(int *cnt)
 {
-	struct pci_dev *pci = NULL;   
+	struct pci_dev *pci = NULL;
 	int i, probe = 0;
 	IXJ *j = NULL;
 
@@ -7745,7 +7745,7 @@ static int __init ixj_probe_pci(int *cnt)
 static int __init ixj_init(void)
 {
 	int cnt = 0;
-	int probe = 0;   
+	int probe = 0;
 
 	cnt = 0;
 
@@ -7887,7 +7887,7 @@ static void DAA_Coeff_US(IXJ *j)
 /*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[2] = 0x2D; */
 /*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[1] = 0x62; */
 /*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[0] = 0x2D; */
-	/* Bytes for Ringing part 2 (06):13,42,A6,BA,D4,73,CA,D5 */ 
+	/* Bytes for Ringing part 2 (06):13,42,A6,BA,D4,73,CA,D5 */
 /*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[7] = 0x2D; */
 /*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[6] = 0x62; */
 /*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[5] = 0xA6; */
-- 
1.7.9.4



-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

