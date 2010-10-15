Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0JOBrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 21:47:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34083 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab0JOBrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 21:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=I9xg8NWUAw9N0dyKh3KFbyChWPL/tg1S/w+3WoKbRcpcSIayiFAfLfGeEmbZ5jDOiU
         W3c5qPmJffvi9pz6F/R9GLY3aAN+v8BxofkSr7Ino1pBs+vIFPiK35XILHZQAeoGagd1
         oUeuAk+S+1qR/Q2wARF6Un7g/0kpXvmw5WtU8=
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <1287078495-11722-1-git-send-email-nacc@us.ibm.com>
References: <1287078495-11722-1-git-send-email-nacc@us.ibm.com>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Thu, 14 Oct 2010 20:47:01 -0500
Message-ID: <AANLkTi=9OBaAj8QkwjwbgmUj8_XK7NFwOA9dv73Tk=hD@mail.gmail.com>
Subject: Re: [RFC PATCH] ppc: don't override CONFIG_PPC_PSERIES_DEBUG
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Neuling <mikey@neuling.org>, Frans Pop <elendil@planet.nl>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2010 12:48, Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> These files undef DEBUG, but I think they were added before the ability
> to control this from Kconfig.

Right.

> It's really annoying to only get some of
> the debug messages!

I don't get the big picture.  Will there be some CONFIG_DEBUG_EEH in Kconfig?
or just some option to turn on DEBUG for all powerpc-related files?

Or maybe I am demonstrating my utter ignorance of some new whiz-bang
Kconfig technology?

Anyway, I see no harm in the EEH portion of the patch.

--linas
