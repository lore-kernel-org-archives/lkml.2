Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1JKKNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:13:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab1JKKNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:13:07 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] genksyms: Ignore changes to internal files
Date: Tue, 11 Oct 2011 12:12:46 +0200
Message-Id: <1318327969-24807-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series teaches genksyms to ignore changes to internal files (those
defined in the source file itself). See patch 2/3 for the main part.

Michal


Michal Marek (3):
  genksyms: Minor parser cleanup
  genksyms: Do not expand internal types
  genksyms: Regenerate lexer and parser

 scripts/genksyms/genksyms.c          |    3 +-
 scripts/genksyms/genksyms.h          |    4 +-
 scripts/genksyms/lex.l               |    8 +
 scripts/genksyms/lex.lex.c_shipped   |   12 +-
 scripts/genksyms/parse.tab.c_shipped |  645 ++++++++++++++++++----------------
 scripts/genksyms/parse.tab.h_shipped |    7 +-
 scripts/genksyms/parse.y             |   40 ++-
 7 files changed, 393 insertions(+), 326 deletions(-)

-- 
1.7.6.1

