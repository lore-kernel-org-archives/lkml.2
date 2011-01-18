Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab1ARQBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:01:09 -0500
Received: from mxs.selfip.ru ([77.221.143.26]:56391 "EHLO mxs.selfmail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752322Ab1ARQBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:01:07 -0500
X-ACL-SPF: 
Subject: Re: [ANN] ulatencyd 0.3.1
From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Reply-To: v.tolstov@selfip.ru
To: Daniel Poelzleithner <poelzi@poelzi.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4D357204.3090505@poelzi.org>
References: <4D357204.3090505@poelzi.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Selfip.Ru
Date: Tue, 18 Jan 2011 18:59:29 +0300
Message-ID: <1295366369.3015.1.camel@mobile>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-ACL-DATA: Invalid Message-Id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 11:57 +0100, Daniel Poelzleithner wrote:
> Hi all,
> 
> I'm happy to announce the release of ulatencyd 0.3.1
mobile build # cmake ../ulatencyd-0.3.1/
-- The C compiler identification is unknown
CMake Error at /usr/share/cmake/Modules/CMakeCInformation.cmake:37
(GET_FILENAME_COMPONENT):
  get_filename_component called with incorrect number of arguments
Call Stack (most recent call first):
  CMakeLists.txt:2 (project)


CMake Error: your C compiler: "" was not found.   Please set
CMAKE_C_COMPILER to a valid compiler path or name.
-- Configuring incomplete, errors occurred!



mobile build # gcc --version
gcc (Exherbo gcc-4.5.1) 4.5.1
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is
NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.



