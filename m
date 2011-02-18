Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab1BRKK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:10:28 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46831 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab1BRKKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:10:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BJNPI0yyWpeXyxHUs8DbJABIu1rQbmbhqXX4kCEA8K9/LddOTutx8fH7FlyNcy62m/
         dZSPp2g5O7za3ynFJc9QVPgNJuyRyDCNMuRHCigjTexE/Gw8lLUImXyVD/BsXnoHkgMf
         wGZU7nsMeKlL522/QLodsAt4fWLaFznXBBRY4=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1102172249020.5315@skynet.skynet.ie>
References: <alpine.DEB.2.00.1102172249020.5315@skynet.skynet.ie>
Date: Fri, 18 Feb 2011 12:10:22 +0200
Message-ID: <AANLkTi=6efAdh76uO5Qeq8FiRWOFQW-MBUWJWxzT1rhf@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nouveau OpenGL regresion

Tools used: http://packages.ubuntu.com/maverick/misc/glmark2

With 2.6.38-rc5 latest git:
nv50_screen_get_param:162 -  Unknown PIPE_CAP 11
===================================================
    glmark2 10.07.1
===================================================
    OpenGL Information
    GL_VENDOR:     nouveau
    GL_RENDERER:   Gallium 0.4 on NV92
    GL_VERSION:    2.1 Mesa 7.9-devel
===================================================
Precompilation
    Vertex array                  FPS: 105
    Vertex buffer object          FPS: 267
Texture filtering
    Nearest                       FPS: 295
    Linear                        FPS: 299
    Mipmapped                     FPS: 308
Shading
    GLSL per vertex lighting      FPS: 227
    GLSL per pixel lighting       FPS: 260
===================================================
Your glmark2 Score is 727  ^_^
===================================================


With Linux ubuntu 2.6.35-25-generic #44-Ubuntu SMP Fri Jan 21 17:40:44
UTC 2011 x86_64 GNU/Linux:

nv50_screen_get_param:162 -  Unknown PIPE_CAP 11
===================================================
    glmark2 10.07.1
===================================================
    OpenGL Information
    GL_VENDOR:     nouveau
    GL_RENDERER:   Gallium 0.4 on NV92
    GL_VERSION:    2.1 Mesa 7.9-devel
===================================================
Precompilation
    Vertex array                  FPS: 265
    Vertex buffer object          FPS: 599
Texture filtering
    Nearest                       FPS: 687
    Linear                        FPS: 683
    Mipmapped                     FPS: 717
Shading
    GLSL per vertex lighting      FPS: 480
    GLSL per pixel lighting       FPS: 524
===================================================
Your glmark2 Score is 1628  ^_^
===================================================
