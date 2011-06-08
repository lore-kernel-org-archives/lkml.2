Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1FHCKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 22:10:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52166 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab1FHCKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 22:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KX1XKvlrqZzeilPMWTiFG4CUB1zRqXLLVWmXnA3DtG1huVB1sZ5Dr13KZAnzNr8wom
         a8D2H3X3oZCmlhumqzHwq+fR/mztn6BZD+T0H4UrCZ2tzVOzEJzhoIa+vbFOi0oGmiKl
         B/S1paJkldQIxuiAAA91CEX2+OQ+Q8bFZFXnY=
MIME-Version: 1.0
In-Reply-To: <1307494181.2874.214.camel@pasglop>
References: <1307472447-1656-1-git-send-email-ericvh@gmail.com>
	<1307494181.2874.214.camel@pasglop>
Date: Tue, 7 Jun 2011 21:10:31 -0500
Message-ID: <BANLkTik596Oo4MTmKO62pmF2yXhYv8Nsvg@mail.gmail.com>
Subject: Re: [PATCH] [RFC][V3] bluegene: add entry to cpu table
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +#define PPC_FEATURE_HAS_FPU_FP2              0x00000040
>
> Any chance for a better name ?
>

That's the official external name,  it sucks.  I'm happy to
PPC_FEATURE_DOUBLE_HUMMER if you'd prefer, otherwise I'm not feeling
too creative, but am open to artistic suggestions.

       -eric
