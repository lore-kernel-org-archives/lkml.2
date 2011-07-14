Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1GNAaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:30:21 -0400
Received: from mail.lang.hm ([64.81.33.126]:50705 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1GNAaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:30:20 -0400
Date: Wed, 13 Jul 2011 17:30:19 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: best way to handle multi-line kernel messages
Message-ID: <alpine.DEB.2.02.1107131723410.16335@asgard.lang.hm>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a query was made on the rsyslog mailing list about the possibility of 
rsyslog handling kernel messages better. Currently each line of logs is a 
separate log entry (and as log entries traverse networks there are thigns 
taht can cause them to get re-ordered). It would be nice to be able to 
combine multi-line logs into one log entry.

The problem is figuring out how to tell when one log entry finishes and 
the next starts.

>From examining logs it looks like follow-up lines are frequently (but not 
always) indented with some form of whitespace (this indentation taking 
place after the timestamp if that's enabled)

but this is not consistantly the case.

I suspect that there is not currently any good way for something to really 
tell when one log entry has finished and another is starting, but I wanted 
to ask here if there is anything that I should be able to rely on (with 
the thought that fixing log messages that don't work that way coudl be 
somethign for -janitors or newbes to work on)

or is this a completely hopeless task that people receiving logs should 
not even try to do?

David Lang
