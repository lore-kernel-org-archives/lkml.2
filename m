Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1LLPlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:41:40 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36340 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026Ab1LLPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:41:38 -0500
Message-ID: <1323704494.1765.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] kref: add function for reading kref value
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Daniel Baluta <daniel.baluta@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, adobriyan@gmail.com
Date: Mon, 12 Dec 2011 16:41:34 +0100
In-Reply-To: <CAEnQRZCZdPw9eWVmdvhtF7KCQkYpLMrkhv5qd5xYckxWksN+0w@mail.gmail.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
	 <20111212150255.GA7506@kroah.com>
	 <CAEnQRZBiVDAHH+uZ=Ugk=UP5qSvvMViGTM-bRWr+E27zivOUug@mail.gmail.com>
	 <1323703934.1765.15.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CAEnQRZCZdPw9eWVmdvhtF7KCQkYpLMrkhv5qd5xYckxWksN+0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 décembre 2011 à 17:39 +0200, Daniel Baluta a écrit :

> Ok, for the moment it seems to be a bad idea. But my intention is
> to integrate kref to networking code, and then to write a general
> debugging tool for refs.
> 
> Tracking down reference count problems is hard, and this tool can
> really help everyone.

I dont think kref will help you that much, because its used everywhere.

Adding a general debugging tool will provide too much noise.

Instead, we (network dev) add debugging points where we want.



