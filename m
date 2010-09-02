Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0IBTdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:33:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42728 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0IBTdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Pxtvi4oVrWyBwaXksQHPMmhnKv7fy3wUXYR9Poz/grC+YuhbqW307KyEk6JIl9h3iV
         +F8TOXCQ8u+f/d8Lkh0SXtNmR+7G2+Nf1kaGDUlJzcpnM/IYzdRvxiy/bZpYEoMajEaC
         0pX8ZyDrVaKzXjFLrUsleQDSOVDVi2KL+MAg0=
MIME-Version: 1.0
In-Reply-To: <20100902121853.e90f6c53.randy.dunlap@oracle.com>
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com> <20100902121853.e90f6c53.randy.dunlap@oracle.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 2 Sep 2010 15:32:50 -0400
Message-ID: <AANLkTimViCmq7hWDgss2GuUv7c0aSLFpF4uOhyJEPNvg@mail.gmail.com>
Subject: Re: [RFC] Fix typos
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 15:18, Randy Dunlap wrote:
> 2.
> -(Warning, pulses on ACK ar inverted by transistor, irq is rised up on sync
> +(Warning, pulses on ACK ar inverted by transistor, irq is rose up on sync
>
> I'm not so sure about "is rose up" being better.  and what about "ar"?

"irq is raised on sync"
-mike
