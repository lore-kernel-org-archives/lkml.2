Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab1EVETR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 00:19:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65486 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1EVETI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 00:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AF05iul38zbenEs9wUWKNWlXQ3LDwwn0+23gTUaNL2JxLvKZ3m6wrEL4/VNJfx9myx
         TDm8kU6NlXswac0E0EFE5UgBELQlONGtbqxYCRGvMWXqnLmYSQSULF/EW9RRa54gRz38
         jKPB+ttpKqbNdcso/+fcCwaT39mevS4WzSZUA=
MIME-Version: 1.0
In-Reply-To: <20110517153546.GB3762520@jupiter.n2.diac24.net>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
	<3A54AB469A0294933EAC2257@nimrod.local>
	<m1fwoqoapn.fsf@fess.ebiederm.org>
	<20110517111148.GA3762520@jupiter.n2.diac24.net>
	<m1mxil9z2p.fsf@fess.ebiederm.org>
	<20110517153546.GB3762520@jupiter.n2.diac24.net>
Date: Sun, 22 May 2011 01:19:07 -0300
Message-ID: <BANLkTingC=uR2dh=oo4=K7xDj9D7WjF2YA@mail.gmail.com>
Subject: Re: [PATCH 0/7] Network namespace manipulation with file descriptors
From: Renato Westphal <renatowestphal@gmail.com>
To: David Lamparter <equinox@diac24.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alex Bligh <alex@alex.org.uk>,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

I'm happy to see that these patches have been integrated into the
mainstream kernel, as you know I'm using them for a while and they are
a essential part of my MPLS/BGP VPN solution, which I will release to
the open-source community anytime soon.

It would also be good if the MPLS core get integrated into mainstream,
but that's another discussion ;)

-- 
Renato Westphal
