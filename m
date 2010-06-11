Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357Ab0FKOhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 10:37:48 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33459 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760203Ab0FKOhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 10:37:47 -0400
X-Sasl-enc: /LDHge0kq467DCau7N5CyJBSzgVQpoYNlZEi5qW4TP3U 1276267040
Date: Fri, 11 Jun 2010 11:37:17 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Brian Gordon <legerde@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Aerospace and linux
Message-ID: <20100611143717.GF28084@khazad-dum.debian.net>
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
 <4C112E7B.1040101@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C112E7B.1040101@nortel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Chris Friesen wrote:
> On 06/10/2010 11:29 AM, Brian Gordon wrote:
> >     When these SEU can be detected some action may be taken to improve
> > the behaviour of the system  (log a fault and reset in order to
> > refresh things from scratch?).   So the first question becomes how to
> > detect an SEU.
> 
> I do work in telco stuff.  We use ECC RAM, turn on ECC/parity on the
> various buses, enable error-checking in the hardware, etc.

Let's not forget that the hardware better have unassisted scrubbing
(rewrite cells where an CE is detected), because we don't scrub when
we are notified of a CE.

Background scrubbing might also be something to look for (run over all
RAM over a large period of time, to catch dormant CEs and fix them
before they become UEs).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
