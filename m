Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab1KYOJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:09:05 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62369 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1KYOJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:09:03 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 25 Nov 2011 15:09:02 +0100
Message-ID: <CA+icZUV10tQu3AHx5WLTbb4Bc=O_mdvw0Gi_K0FbG0ud+2ob2A@mail.gmail.com>
Subject: LKML offline mail-archives not accessible
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: j@jasper.es
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying for example <http://lkml.org/lkml/last100/> gives this
error-messages back:

<br />
<b>Warning</b>:  DOMDocument::loadXML() [<a
href='domdocument.loadxml'>domdocument.loadxml</a>]: Input is not
proper UTF-8, indicate encoding !
Bytes: 0xEF 0x20 0x2E 0x2E in Entity, line: 1359 in
<b>/srv/lkml.org/scripts/getlist.php</b> on line <b>133</b><br />
<br />
<b>Warning</b>:  XSLTProcessor::transformToXml() expects parameter 1
to be object, boolean given in
<b>/srv/lkml.org/scripts/getlist.php</b> on line <b>136</b><br />
XSLT error or server overload; admin notified. The system should heal
itself, please try again in a few minutes<br />
<b>Fatal error</b>:  Call to undefined function xslt_error() in
<b>/srv/lkml.org/scripts/getlist.php</b> on line <b>160</b><br />

- Sedat -
