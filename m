Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0LMHsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 02:48:09 -0500
Received: from emita2.mittwald.de ([188.94.250.252]:53093 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab0LMHsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 02:48:07 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Start dropping PCMCIA from compat-wireless for 2.6.38+
Date: Mon, 13 Dec 2010 08:46:16 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35; KDE/4.5.3; i686; ; )
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-bluetooth" <linux-bluetooth@vger.kernel.org>
References: <AANLkTik4W+UxgyPjVyHDeEFTRCkXdDBQ9obgPkpnhzGW@mail.gmail.com>
In-Reply-To: <AANLkTik4W+UxgyPjVyHDeEFTRCkXdDBQ9obgPkpnhzGW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012130846.16522.holgerschurig@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, if the burden is not too much, keep it for the benefit of 
embedded people.

If you have some embedded device (e.g. ARM based), it's usually not so 
easy to hieve this device to newest 2.6.3[5-7] kernel. However, it's 
easy to use your adapted kernel, and compile compat-wireless against it.

I'm in such a situation with libertas_cs.

Greetings,
Holger

-- 
Homepage: http://www.holgerschurig.de
