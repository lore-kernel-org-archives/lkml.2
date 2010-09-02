Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab0IBUpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:45:45 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46899 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab0IBUpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=gtP/+XpLZ4N+8/NhVgVK88rSc8U1BhiHgIZUWs4j3BAgfodZi/E5IXoNo0m0E1Uc/G
         Iomwpy9s7I8MyEU2q1ooxBg3cR7CNAmIhn4N+wIgovbw9E2GhEGkYHhF7y1Y/c+DFfSU
         F9k3DxDqj+g/DgzePJTVvVMIbkPeDPnZs0j+Q=
MIME-Version: 1.0
In-Reply-To: <20100902132558.63a90e0d.randy.dunlap@oracle.com>
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com>
 <20100902121853.e90f6c53.randy.dunlap@oracle.com> <AANLkTinehv75C+xhsDA_7HHoT9m_BkmL1aE_oyM9BJO4@mail.gmail.com>
 <4C800266.1000005@oracle.com> <20100902132558.63a90e0d.randy.dunlap@oracle.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Thu, 2 Sep 2010 17:45:23 -0300
Message-ID: <AANLkTimDKGDy9JGuC1nL1pZa4q07X5q4sr7q7GW5KGup@mail.gmail.com>
Subject: Re: [RFC] Fix typos
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 17:25, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Kconfig prompts and help text are also user-visible strings.
>
> I just saw this one:
>
> bool "ET&T USB series TC4UM/TC5UH touchscreen controler support" if EMBEDDED

I've just added the controler->controller fix to my dictionary.

-- 

Lucas De Marchi
