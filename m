Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab2JUWUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 18:20:50 -0400
Received: from smtprelay0100.b.hostedemail.com ([64.98.42.100]:35942 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932634Ab2JUWUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 18:20:49 -0400
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::,RULES_HIT:152:355:379:541:582:945:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2108:2194:2199:2378:2379:2393:2525:2560:2563:2682:2685:2857:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3868:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:5007:6261:7679:7875:7903:9025:9108:10004:10400:10848:11658:11914:12043:12050:12517:12519:12698:12737,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1225
Date: Sun, 21 Oct 2012 22:20:06 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1497554942.41660.1350858006886.JavaMail.mail@webmail04>
References: <Pine.LNX.4.44L0.1210211121370.14867-100000@netrider.rowland.org>
Subject: A strange Linux 3.6 bug: corrupted page table
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.1.245]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There's something strange going on with kernel 3.6.x:

https://bugzilla.redhat.com/show_bug.cgi?id=859188

My RAM is heavily tested - some time ago I ran memtest86 for 2 hours straight and
it showed no errors, besides neither my RAM, nor my CPU are overclocked.

All three people who experience this problem have Linux 3.6.x installed and this bug
didn't affect them when they ran Linux 3.5.x.

Best wishes,

Artem
