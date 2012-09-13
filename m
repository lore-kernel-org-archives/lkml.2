Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab2IMASo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:18:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50779 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab2IMASk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 20:18:40 -0400
MIME-Version: 1.0
Date: Wed, 12 Sep 2012 20:18:39 -0400
Message-ID: <CAOqfy0W67ZZ59+jUjEG8dLc9BSyqnYnnP+TpB7kz6VJVnYchsA@mail.gmail.com>
Subject: Various things Linux doesn't have/doesn't need
From: Rich Lawlman <richlawlman@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is by fine, unbiased analysis I propose the following:

  For one, drop all support for cpu archs except ARM. Dropping support
will reduce development strain, and x86 has no foreseeable future
anyways. This will allow Linux to accelerate its development pace on
the one thing it currently has potential in; low-powered devices such
as mobile/embedded, as Linux on the desk is a virtual wasteland.

  In addition, no one cares about the true state or existence of their
files, and the assumption they do is why Linux scares new guys and the
iPhone became popular. The kernel should instead make the filesystem
"invisible" to the user; by default making only user files visible
from a file manager and making only files related to a particular app
available in that app. More secure, more simple, easier for the
simpleton.
