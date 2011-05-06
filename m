Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1EFHYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:24:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33719
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260Ab1EFHYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:24:53 -0400
Date: Fri, 06 May 2011 00:24:21 -0700 (PDT)
Message-Id: <20110506.002421.112590342.davem@davemloft.net>
To: cebbert@redhat.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        davej@redhat.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [patch 34/38] can: Add missing socket check in
 can/bcm release.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110506031654.4e2d6e9d@katamari>
References: <20110506001225.GA10547@kroah.com>
	<20110506001210.638661956@clark.kroah.org>
	<20110506031654.4e2d6e9d@katamari>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>
Date: Fri, 6 May 2011 03:16:54 -0400

> On Thu, 05 May 2011 17:11:06 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
>> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
>> 
>> ------------------
>> 
>> From: Dave Jones <davej@redhat.com>
>> 
>> commit c6914a6f261aca0c9f715f883a353ae7ff51fe83 upstream.
>> 
> 
> Can we get the twin to that patch in too?
> 
> commit 10022a6c66e199d8f61d9044543f38785713cbbd
> "can: add missing socket check in can/raw release"

Indeed, Greg please add this.
