Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2DWWgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:36:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56497 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2DWWgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:36:23 -0400
MIME-Version: 1.0
In-Reply-To: <1335220202-32533-1-git-send-email-grant.likely@secretlab.ca>
References: <1335220202-32533-1-git-send-email-grant.likely@secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 23 Apr 2012 16:36:03 -0600
X-Google-Sender-Auth: 8PkS66snoijKp3LrrVg3ApSIdVw
Message-ID: <CACxGe6ua32AL_wzaLvjBWx3T5ipF=JdHs46E+baddn_NLxG5kg@mail.gmail.com>
Subject: [PATCH v2 0/2] Get rid of PowerPC users of NR_IRQS
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops. Flubbed the subject on the below email.  This is the cover
letter for the NR_IRQS patches, so the subject should have included
"[PATCH v2 0/2]"

On Mon, Apr 23, 2012 at 4:30 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Hi Ben,
>
> Here's the 2nd version of the NR_IRQS cleanup patches for PowerPC.  I've
> addressed your comments and compile tested them, but I've not tried to
> boot.  If they check out for you then they should probably go into v3.4.
>
> g.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
