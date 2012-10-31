Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422739Ab2JaSGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:06:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55096 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935779Ab2JaSF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:05:57 -0400
Date: Wed, 31 Oct 2012 11:05:51 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>,
        skinsbursky@parallels.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, baggins@pld-linux.org,
        arekm@pld-linux.org
Subject: Re: [PATCH] lockd: fix races in per-net NSM client handling
Message-ID: <20121031180550.GD30432@elie.Belkin>
References: <1689813.hptKgzjpAu@localhost>
 <20121031174946.GA13591@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20121031174946.GA13591@kroah.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Greg KH wrote:
> On Wed, Oct 31, 2012 at 06:27:36PM +0100, Paweł Sikora wrote:

>> the patch metioned in https://lkml.org/lkml/2012/10/24/175 seems to fix
>> the 3.6.3 oops (while 3.6.2 works fine) at 16-cores opteron server.
>> please queue this path for 3.6.$next.
>
> Is it in Linus's tree already?  If so, what is the git commit id?

One of

  a4ee8d978e47 LOCKD: fix races in nsm_client_get
  e498daa81295 LOCKD: Clear ln->nsm_clnt only when ln->nsm_users is zero

both of which were included in v3.6.5.

Hope that helps,
Jonathan
