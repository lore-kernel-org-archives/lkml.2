Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0CZMAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:00:34 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:62414 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0CZMAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=khr1INtnltH/06ul22kMNystf1zoClGtfXED0yk5fAK+CxU2VBg+6zKQhj7msmAuGj
         0mXw5+q2Fx5tjUWUeYimjHzIjFdHUjScL+dAaw9q4RnH4vbN0OyUNrFFJhfoDzpJenVk
         BBQTu6ukaF2poMnzPgG1YOGmdVr8fWiRtyKhA=
MIME-Version: 1.0
In-Reply-To: <84621a61003241635h65687366t6b28148281d529c9@mail.gmail.com>
References: <84621a61003241128x3afbcea1w387aeaa68c887320@mail.gmail.com> 
	<g76h4xrt5j1pw2kk3tUYAxe124vaj_firegpg@mail.gmail.com> <84621a61003241635h65687366t6b28148281d529c9@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Fri, 26 Mar 2010 05:00:11 -0700
Message-ID: <a36005b51003260500v6d8b7a5av1bbba848cc8998a4@mail.gmail.com>
Subject: Re: behavior of recvmmsg() on blocking sockets
To: Brandon Black <blblack@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 16:35, Brandon Black <blblack@gmail.com> wrote:
> +                /* MSG_WAITFORONE turns on MSG_DONTWAIT after one packet */
> +               if (!datagrams++ && flags & MSG_WAITFORONE)
> +                       flags |= MSG_DONTWAIT;

There should be an extra pair of parenthesis around the & operands but
aside from that I could imagine this to work.

Would be nice if the netdev folks would respond.
