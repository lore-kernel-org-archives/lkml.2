Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0DHCkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 22:40:55 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:58232 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab0DHCkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 22:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=g0KHdBLqd3WrSbNwzKp22wZ3XcZPMg4Vpy5a7aZiwAeFL2soOUrsXt3NMepEAhAf2+
         Evs9haM+NBco6RtbcdKx40TNzTzlxD7bwF7PG7FAfl3MYZWlSL93/WP9kLsoN+x4abWA
         v5zy/3iu/FvciFOm4QxvbVpmqge3CW5kNcJfE=
MIME-Version: 1.0
Date: Wed, 7 Apr 2010 19:40:47 -0700
Message-ID: <l2rdd18b0c31004071940r2926fcefqe919eb3d7ab82ca4@mail.gmail.com>
Subject: reported regressions
From: Justin Mattock <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

here is a bug report that was issued for
2.6.31 that still is there with the latest:
https://bugzilla.kernel.org/show_bug.cgi?id=14429
attached is a patch that fixed it for me
please have the proper people look at so we
can close this.

-- 
Justin P. Mattock
