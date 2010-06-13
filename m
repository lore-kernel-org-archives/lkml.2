Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab0FMO6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 10:58:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58826 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab0FMO5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 10:57:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Frederic Weisbecker" <fweisbec@gmail.com>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YPGdyfWGvNK.A.Jo.h7OFMB@chimera>
Subject: [Bug #15805] reiserfs locking
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jun 2010 16:48:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15805
Subject		: reiserfs locking
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2010-04-15 21:02 (60 days old)
Message-ID	: <t2ka4423d671004151402n7b2dc425mdc9c6bb9640d63fb@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127136535323933&w=2
Handled-By	: Frederic Weisbecker <fweisbec@gmail.com>


