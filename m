Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1KGLw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:52:27 -0500
Received: from fallback2.mail.ru ([94.100.176.87]:40206 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1KGLw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:52:26 -0500
X-Greylist: delayed 795 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 06:52:26 EST
Date: Mon, 7 Nov 2011 19:38:58 +0800
From: danila.st@mail.ru
X-Priority: 3 (Normal)
Message-ID: <123693291.20111107193858@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: IPSec IP range in Linux kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
X-Spam: Not detected
X-Mras: Ok
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

To begin with I'm from Russia. So I apologize in advance for the English from google translate. :)

Plus I had never had to deal with mailing lists. So do not kick me immediately if not written on the topic. But sincerely hope that the requested address.

Initially, I tried to write a letter directly to David Miller. He told me what to write and not directly to the mailing list. To what exactly I did not know why I write here.

I beg you take me seriously! The fact that the Russian people are not located in the most serious and mutual respect.

Now describe directly the problem itself. In our organization for the organization of IPSec encrypted connection used by devices such as Zyxel Zywall. Below is a diagram:

server (zywall)
192.168.1.0/24-----------------192.168.7.1-192.168.7.5 (client 1)
    | |
    | ------------------- 192.168.7.6-192.168.7.10 (client 2)
    |
    --------------------------- 192.168.7.11-192.168.7.15 (client 3)

Explanation of the scheme: at the head zywall prescribed set of IPSec connections. One feature of these rules is that all these compounds combine the main enterprise network 192.168.1.0/24 on the other subnet 192.168.7.0/24, broken into pieces, each of which contains a range of 5 are forwarding addresses.

Instead, head server, we decided to use a server running Linux. And immediately faced with the problem - the connection in Linux you can install only one address / subnet. Ability to connect to a range of addresses is not as such. As a result, the connection fails - fails at the stage of the harmonization of policies.

Therefore appeal to you. Tried to contact the Russian representative office zyxel. Clear answers are not received. Apparently they are not developers, just distributors. Tried to write on the forums. Received only a proposal to replace the range on the subnet. Maybe they're right, but the question arises, why this feature is implemented in devices company zyxel?

In general, writing to you with a rational proposal to help you add this feature in Linux. Well, and related issues:

1) Describe the table structure policies SADB, SPD? Where in the source code they describe?
2) Please explain IPSec device subsystem in Linux. Perhaps you have links to the appropriate literature, description, documentation?

P.S. I'd love to hear the answer himself and David Miller, as is its design.

