Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2CVWgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 18:36:36 -0400
Received: from mailout08.t-online.de ([194.25.134.20]:59363 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab2CVWgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 18:36:35 -0400
Message-ID: <4F6BA960.6020003@t-online.de>
Date: Thu, 22 Mar 2012 23:36:16 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>, arekm@maven.pl,
        Jared <nitro@legroom.net>, dilieto@lineone.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: override for PCI legacy power management
References: <4F69BE2E.7070903@t-online.de> <20120321083205.360a7a3b@nehalam.linuxnetplumber.net> <CAErSpo67PEaZ6JuMUntWLfR8SUpQgZERD_cKV6rWd=FF0tZ6DQ@mail.gmail.com>
In-Reply-To: <CAErSpo67PEaZ6JuMUntWLfR8SUpQgZERD_cKV6rWd=FF0tZ6DQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: rxE5u0ZJwhtKH5KKYG8mSuZ1Mp5Jb4JpH3ozZewLz+fubt4NXtQguWfFjJ33BtQg80
X-TOI-MSGID: 84487b8e-9e6f-4e08-846f-c4a69e8549bd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.03.2012 21:22, schrieb Bjorn Helgaas:
> It looks like this requires a user to figure out that he might be suffering from this problem, then use this module parameter to work around it. How would a user figure that out? Can we do it automatically to save him the trouble?

It´s easy to dmi_match() known broken systems - I have dmidecode outputs of four systems that definitely need the patch.
Two ASUSTek P5* mainboards with AMI BIOSes, two AOpen i915G* mainboards with Award/Phoenix BIOSes.

cu,
  Knut
