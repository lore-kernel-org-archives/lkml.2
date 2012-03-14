Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab2CNHRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:17:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46126 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2CNHRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:17:31 -0400
Date: Wed, 14 Mar 2012 00:17:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Corentin Chary <corentin.chary@gmail.com>
cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch -next 1/2] drivers, samsung-laptop: fix initialization
 of sabi_data in sabi_set_commandb
In-Reply-To: <CAHR064gzke5o4C8cg2qH1d4VuXTMmqV-sAaiOv5O650qjc01sw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1203140016070.21777@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203132258160.5229@chino.kir.corp.google.com> <CAHR064gzke5o4C8cg2qH1d4VuXTMmqV-sAaiOv5O650qjc01sw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, Corentin Chary wrote:

> David, just in case, I found this mail in my spam folder, probably
> because your smtp server is not allowed to send @google.com mails.
> 

Known gmail issue for people sending emails to LKML from google.com :)

> Also, with which version of gcc is this necessary ? Old version worked
> with 4.5 and 4.6.
> 

I'm using 4.4.3.
