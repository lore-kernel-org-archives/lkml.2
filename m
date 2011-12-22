Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1LVSjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:39:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45077 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1LVSjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:39:33 -0500
Date: Thu, 22 Dec 2011 19:39:29 +0100
From: Marco Navarra <fromenglish@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Checkpatch possible false positive
Message-ID: <20111222183928.GB16245@europa.casa.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

after running checkpatch on some files, it returns "ERROR: Macros with
complex values should be enclosed in parenthesis" while processing
code like this:
#define SOMEVALUE 'x'

It happens on agpgart.h, checkpatch complains about line 30 that
corresponds to:
#define AGPIOC_BASE       'A'
Running it on elf.h returns the same error on these lines
#define ELFMAG1         'E'
#define ELFMAG2         'L'
#define ELFMAG3         'F'

Do you think this could be a false positive?
The tree is linux-next and checkaptch version is 0.32


Thank you                                                                      
Marco
