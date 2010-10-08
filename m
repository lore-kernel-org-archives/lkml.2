Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab0JHPFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:05:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476Ab0JHPE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=l+RuIM8qRH4joeDQefuHTWsZdeD9G6oiVukh2dioy52sbRl3AbTiMlRy5OROCaIyem
         oOkxbuSBGraXk5xJusOM+ooGc/mM/18VhB0HrnKt3mZKbBJP8T6DyzHQD/nQeZhLstw+
         diVWnx1lYMcmaAJJfboUszc4QX07TMDwD7Hs4=
MIME-Version: 1.0
Date: Fri, 8 Oct 2010 12:04:58 -0300
Message-ID: <AANLkTiksCxC7-4NwmU5Nufc6rE1E3qjcsnJGw0gKbk8o@mail.gmail.com>
Subject: Re: Tips on debugging suspend/resume failure
From: Lima Union <limaunion@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to let you know that I'm experiencing a similar problem, upon
resuming from s2ram the machine just gets stuck (no access thru
keyboard nor ssh, just replies from ping). The latest kernel that I
can use without this problem is 2.6.33.7 (rock solid), all newer
kernels that I tried after that one have the same issue (included
2.6.35.6) in a random way, ie: in ten suspend/resume cycles it may
happen once. I'm not a programmer so I can't really help here. (I'm
not subscribed to LKML).
Regards.LU.
