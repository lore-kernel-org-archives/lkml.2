Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab2HSC7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:59:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:42537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab2HSC5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="135817670"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, herbert@gondor.hengli.com.au
Subject: [PATCH 36/74] lto, crypto, camelia: Make camelia tables used by assembler __visible
Date: Sat, 18 Aug 2012 19:56:32 -0700
Message-Id: <1345345030-22211-37-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: herbert@gondor.apana.org.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/crypto/camellia_glue.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index eeb2b3b..f290db7 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -91,7 +91,7 @@ static void camellia_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 }
 
 /* camellia sboxes */
-const u64 camellia_sp10011110[256] = {
+__visible const u64 camellia_sp10011110[256] = {
 	0x7000007070707000, 0x8200008282828200, 0x2c00002c2c2c2c00,
 	0xec0000ecececec00, 0xb30000b3b3b3b300, 0x2700002727272700,
 	0xc00000c0c0c0c000, 0xe50000e5e5e5e500, 0xe40000e4e4e4e400,
@@ -180,7 +180,7 @@ const u64 camellia_sp10011110[256] = {
 	0x9e00009e9e9e9e00,
 };
 
-const u64 camellia_sp22000222[256] = {
+__visible const u64 camellia_sp22000222[256] = {
 	0xe0e0000000e0e0e0, 0x0505000000050505, 0x5858000000585858,
 	0xd9d9000000d9d9d9, 0x6767000000676767, 0x4e4e0000004e4e4e,
 	0x8181000000818181, 0xcbcb000000cbcbcb, 0xc9c9000000c9c9c9,
@@ -269,7 +269,7 @@ const u64 camellia_sp22000222[256] = {
 	0x3d3d0000003d3d3d,
 };
 
-const u64 camellia_sp03303033[256] = {
+__visible const u64 camellia_sp03303033[256] = {
 	0x0038380038003838, 0x0041410041004141, 0x0016160016001616,
 	0x0076760076007676, 0x00d9d900d900d9d9, 0x0093930093009393,
 	0x0060600060006060, 0x00f2f200f200f2f2, 0x0072720072007272,
@@ -358,7 +358,7 @@ const u64 camellia_sp03303033[256] = {
 	0x004f4f004f004f4f,
 };
 
-const u64 camellia_sp00444404[256] = {
+__visible const u64 camellia_sp00444404[256] = {
 	0x0000707070700070, 0x00002c2c2c2c002c, 0x0000b3b3b3b300b3,
 	0x0000c0c0c0c000c0, 0x0000e4e4e4e400e4, 0x0000575757570057,
 	0x0000eaeaeaea00ea, 0x0000aeaeaeae00ae, 0x0000232323230023,
@@ -447,7 +447,7 @@ const u64 camellia_sp00444404[256] = {
 	0x00009e9e9e9e009e,
 };
 
-const u64 camellia_sp02220222[256] = {
+__visible const u64 camellia_sp02220222[256] = {
 	0x00e0e0e000e0e0e0, 0x0005050500050505, 0x0058585800585858,
 	0x00d9d9d900d9d9d9, 0x0067676700676767, 0x004e4e4e004e4e4e,
 	0x0081818100818181, 0x00cbcbcb00cbcbcb, 0x00c9c9c900c9c9c9,
@@ -536,7 +536,7 @@ const u64 camellia_sp02220222[256] = {
 	0x003d3d3d003d3d3d,
 };
 
-const u64 camellia_sp30333033[256] = {
+__visible const u64 camellia_sp30333033[256] = {
 	0x3800383838003838, 0x4100414141004141, 0x1600161616001616,
 	0x7600767676007676, 0xd900d9d9d900d9d9, 0x9300939393009393,
 	0x6000606060006060, 0xf200f2f2f200f2f2, 0x7200727272007272,
@@ -625,7 +625,7 @@ const u64 camellia_sp30333033[256] = {
 	0x4f004f4f4f004f4f,
 };
 
-const u64 camellia_sp44044404[256] = {
+__visible const u64 camellia_sp44044404[256] = {
 	0x7070007070700070, 0x2c2c002c2c2c002c, 0xb3b300b3b3b300b3,
 	0xc0c000c0c0c000c0, 0xe4e400e4e4e400e4, 0x5757005757570057,
 	0xeaea00eaeaea00ea, 0xaeae00aeaeae00ae, 0x2323002323230023,
@@ -714,7 +714,7 @@ const u64 camellia_sp44044404[256] = {
 	0x9e9e009e9e9e009e,
 };
 
-const u64 camellia_sp11101110[256] = {
+__visible const u64 camellia_sp11101110[256] = {
 	0x7070700070707000, 0x8282820082828200, 0x2c2c2c002c2c2c00,
 	0xececec00ececec00, 0xb3b3b300b3b3b300, 0x2727270027272700,
 	0xc0c0c000c0c0c000, 0xe5e5e500e5e5e500, 0xe4e4e400e4e4e400,
-- 
1.7.7.6

