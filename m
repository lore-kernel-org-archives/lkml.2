Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0FTBxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 21:53:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55288 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab0FTBxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 21:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=gbWvsb/o9//b3HtdjDXhxz4OuM6GelBEhQMUxAE3ChyB8c/FkqtMM8bwtuqRpCplGt
         I22dJX3YQCMbS2THlWCQ//0fry7glQm0s9k5vL+ohIGpOaFSXLZ5LI5hcXrnltWY1s+g
         WJEjTkAeXCEzTOsw6adjMK7l0M0AjIg2PyIEc=
MIME-Version: 1.0
Date: Sat, 19 Jun 2010 19:53:31 -0600
Message-ID: <AANLkTinlLLznzl4tX1KABJrTw1nQ3titwV8UAOO4NNeK@mail.gmail.com>
Subject: [ANNOUNCE] Open Cworthy 6-19-2010 x86_64 Fixes
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://cworthylinux.googlecode.com/files/cworthy-06-19-2010.tar.gz

FIXES

Fixed NWSCREEN pointer size mismatch on x86_64
Fixed build problems on x86_64
Fixed Memory Overwrite glibc message on Fedora 13 x86_64
Upgraded memset and memcpy functions for x86_64

Tested on a 4 processor opteron HP Proliant running Fedora Core 13
x86_64 and FC8 ia32

Jeff
