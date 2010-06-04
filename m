Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab0FDWEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 18:04:40 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45689 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab0FDWEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 18:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=eqQ9p4aI7zB2+RStmRcOXxGpCsY/Ba8fj51bgibplwIVoBUAQjZSCl08YXSj6jqcuj
         H5zNXABcoXxwpkvEtWvODpVcHaWzv2UHThkW7goj4VbEkYsOt4WMGOiskQaPZm7GEVIW
         P6Ay3iITA9oVSZOW1KaJ83MI52QgPiBcAbTKs=
MIME-Version: 1.0
In-Reply-To: <AANLkTinSjJsqNvEhJZIE6cJxEkBtg-DO2dqZWMczUy2i@mail.gmail.com>
References: <AANLkTinSjJsqNvEhJZIE6cJxEkBtg-DO2dqZWMczUy2i@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 4 Jun 2010 15:04:17 -0700
Message-ID: <AANLkTik1isTBolg4IDchOlmKqXOLjQoobZrJ-9bb8ZL5@mail.gmail.com>
Subject: Re: Ethernet drivers wiki page
To: netdev@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 2:52 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Where can I start adding documentation for our Ethernet drivers
> upstream? I was hoping for a wiki but I don't think we have a netdev
> one yet. Shall we create one or piggy back on something else? I'm
> reviewing:
>
> https://wiki.kernel.org/
>
> FWIW, I want to see something like this:
>
> http://wireless.kernel.org/en/users/Drivers
>
> But for ethernet.

Since I've stuffed a few ethernet drivers on compat-wireless I might
as well start carrying more. So now we'd have 802.11, Bluetooth and
Ethernet all backported using the same framework, automatically, down
to at least the oldest stable kernel supported listed on kernel.org
and using all a generic compat module.

I want to document all this crap.

  Luis
