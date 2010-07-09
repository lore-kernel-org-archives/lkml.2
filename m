Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0GIBSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:18:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51801 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0GIBS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:18:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=igHdBV3fneLlFGGE0FoFcrsvAHuzfPoZK0NeLLrnqHbs29icIGw8RnXorMh47fs3+2
         3SY5CLFtKqAbLnPMTONbtd5I0r16JXk6DBdUZRlaph7tNF4B14Mw/rF6DcmblO9jhYPJ
         EQSH77OtrLBEPbmDhGdkmB3UlHPSZ8dr72TJg=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 8 Jul 2010 18:18:07 -0700
Message-ID: <AANLkTinLdu_pDfdyluDqkMywhQ66HhMv5Lg5JikHL4Sr@mail.gmail.com>
Subject: Compat-wireless for 2.6.32.y, 2.6.33.y, 2.6.34.y and 2.6.35-rc 
	updated
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each of these kernel releases have been used as bases for new
respective compat-wireless updates:

  * compat-wireless-2.6.32.16.tar.bz2
  * compat-wireless-2.6.33.6.tar.bz2
  * compat-wireless-2.6.34.1.tar.bz2
  * compat-wireless-2.6.35-rc4.tar.bz2

The last one actually has a bit extra stuff, whatever Linus has merged
as of today after rc4.

For details of the changelog between each release and for download
location check the stable compat-wireless page.

http://wireless.kernel.org/en/users/Download/stable

Additionally bleeding edge compat-wireless which uses linux-next
should now be up to date, the "wl" branch should also be up to date
with today's wireless-testing. If there are any issues please let me
know.

  Luis
