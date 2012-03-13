Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab2CMRrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:47:08 -0400
Received: from smtprelay0062.b.hostedemail.com ([64.98.42.62]:55789 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758845Ab2CMRrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:47:06 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2012 13:47:06 EDT
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 2389
Date: Tue, 13 Mar 2012 17:37:11 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <197377679.301107.1331660231517.JavaMail.mail@webmail07>
Subject: Is bugzilla's SSL certificate invalid?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.183.148]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some of my web browsers (google chrome and opera) say that the bugzilla's SSL certificate is invalid.

"The site's security certificate is not trusted!

You attempted to reach bugzilla.kernel.org, but the server presented a certificate issued by
an entity that is not trusted by your computer's operating system. This may mean that the
server has generated its own security credentials, which Google Chrome cannot rely on for
identity information, or an attacker may be trying to intercept your communications. You
should not proceed, especially if you have never seen this warning before for this site."

Subject's public key which my web browsers show:

Modulus (2048 bits):
A5 26 DA 8C 65 33 33 E0 B5 3B 3E 82 CF 23 E6 7A
4F 47 1F 4D D3 A2 27 19 78 7C 4E 94 17 D2 EF 2C
AF 23 2C 9B C5 30 81 AE 69 08 B7 27 3E B1 FE 9B
E6 0D 99 7F C2 0F C2 5A 1A 8F E0 02 41 A2 DF 9B
43 8E 68 5A EF 1C 44 48 37 5B 74 A6 2B 6F 99 E4
83 23 A0 57 55 8A B4 79 22 C4 3E 94 86 60 2F F7
00 C7 4A 13 6D 4D 3B 58 E6 2F B9 AD B0 20 7C 09
6E 0D 00 0B F2 F7 B1 E4 BE C3 EC 4C F3 4E A7 A7
7F 2E D7 08 31 84 52 DF 8E D1 16 04 63 3B F2 75
3D 4D 39 10 48 DC A5 77 72 E9 E0 B2 24 BC 22 D8
01 4B 81 F0 73 8D 2F B4 50 AE 2D AB 4D 47 15 A9
54 2D F3 BF 6A 48 C2 E7 D5 86 FA AA DC 3F F6 22
FF 54 CC F1 B1 36 9A E9 F5 99 CB 82 3F B6 E6 C9
91 43 7E B1 A7 3B 64 D8 71 9F EC EF 3E 1B 4D 49
84 8B 14 7A 91 37 63 D5 FA 2A 8B B5 E4 B2 F9 28
F5 D5 C2 89 46 63 E1 CE BD D9 92 99 5C 4F A0 27

Public Exponent (24 bits):
01 00 01

My OS resolves bugzilla.kernel.org to 198.145.19.204

Should I be concerned?




With respect,

Artem S. Tashkinov
