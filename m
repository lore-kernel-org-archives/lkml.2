Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824Ab2JXNnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:43:53 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:49396 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab2JXNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:43:52 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2012 09:43:52 EDT
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=B72E+5AReoHFOm9k9cHzrmIJDvR8WWhEivKVH6f7yM5c1BKoX83FR+/ulFRl
	De2va5uiH9MfeWIYAKoZ+dK/xYbUb/TPYsNs9iEbQvSiaKDA6R6z4Fyi3
	kEaeFFzx/eUUDyM/HsZ1vf+yw2NTnj2po80oG32J+oiYZ02HHRh09I=;
X-Spam-Processed: mail.digidescorp.com, Wed, 24 Oct 2012 08:37:04 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.27.113
X-Return-Path: prvs=164424fc81=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1351085817.2362.2.camel@iscandar>
Subject: Re: 3.6.0 kernel - ext4 corruption, or?
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 24 Oct 2012 08:36:57 -0500
In-Reply-To: <002101cdb1e1$47972c60$d6c58520$@lucidpixels.com>
References: <002101cdb1e1$47972c60$d6c58520$@lucidpixels.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

False alarm? : 

On Wed, 2012-10-24 at 08:15 -0400, Justin Piszcz wrote: 
> # grep 10.0.0.11 -r /etc
> /etc/posfix.old/master.cf:10.0.0.11:smtp         inet  n       -       -
> -        1    postscreen
> 
> # ls -l /etc/posfix.old/master.cf
> -rw-r--r-- 1 root root 13236 Oct 28  2011 /etc/posfix.old/master.cf
> 
> # ls -ld /etc/postfix.old 
> ls: cannot access /etc/postfix.old: No such file or directory

This is not the same directory (posTfix).

------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>



