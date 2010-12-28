Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab0L1Aiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 19:38:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63570 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab0L1Aio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 19:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=M1rRpzIQChidYBixtZVwM5nDmgrlGrU/TSaisajidldV2DByL7qNiWGhae50a2EVO8
         W95kgP8ROK7LCHGkLzakFi6OVUyYmEl1f+ywGXfKLVemNVM/T7ZdZckAHaf2x3vy+Do7
         rX3F+UkdUZFeNmcoUxBP/cl3IUmHu5WDgv8pM=
MIME-Version: 1.0
In-Reply-To: <1293464210-21649-1-git-send-email-dsterba@suse.cz>
References: <1293464210-21649-1-git-send-email-dsterba@suse.cz>
Date: Tue, 28 Dec 2010 01:38:43 +0100
X-Google-Sender-Auth: UwxLCJfmmDTeOYBvG30HcTYGqWA
Message-ID: <AANLkTimaPn51QZNRFr-L5KgOQTWJf=RzoDSxegAiO_4O@mail.gmail.com>
Subject: Re: [PATCH] Input: bu21013_ts: fix misuse of logical operation in
 place of bitop
From: Linus Walleij <linus.walleij@stericsson.com>
To: David Sterba <dsterba@suse.cz>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Henrik Rydberg <rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

010/12/27 David Sterba <dsterba@suse.cz>:

> CC: Linus Walleij <linus.walleij@stericsson.com>
> CC: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> CC: Henrik Rydberg <rydberg@euromail.se>
> Signed-off-by: David Sterba <dsterba@suse.cz>

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
