Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1ADH7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 02:59:32 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42847 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1ADH7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 02:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=j9y1pVma8jFLlov7qEridb4CQpvzGLPcMAQO/quQUuOjMKWrubKO/by1sHWVtwPj82
         a6I1nh6DB09a89AdcLQffrZE3W9ELZq5GbcAQradA+mahiN7nMx6RSzfjnoPC63Y48ou
         asEaaFWGK9uUq6vmC6f9UGVvSlo7ZTJbdINrA=
MIME-Version: 1.0
Date: Tue, 4 Jan 2011 09:59:29 +0200
Message-ID: <AANLkTins3HdRJ-Y7bCuXFjOhjx+-nxDHSqUxBPuuxFxg@mail.gmail.com>
Subject: Kernel build
From: Anca Emanuel <anca.emanuel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: kernel-team@lists.ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Question: Why I need to rebuild all the modules, if they are already builded.
https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
If I make an one line change, I need to wait one hour to make an new
kernel on an intel core duo at 2GHz sistem ?
