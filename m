Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab1ARQhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:37:42 -0500
Received: from mxs.selfip.ru ([77.221.143.26]:42032 "EHLO mxs.selfmail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751210Ab1ARQhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:37:41 -0500
X-ACL-SPF: 
Subject: Re: [ANN] ulatencyd 0.3.1
From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Reply-To: v.tolstov@selfip.ru
To: Daniel Poelzleithner <poelzi@poelzi.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1295366369.3015.1.camel@mobile>
References: <4D357204.3090505@poelzi.org>  <1295366369.3015.1.camel@mobile>
Content-Type: text/plain; charset="UTF-8"
Organization: Selfip.Ru
Date: Tue, 18 Jan 2011 19:36:51 +0300
Message-ID: <1295368611.3015.4.camel@mobile>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-ACL-DATA: Invalid Message-Id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 18:59 +0300, Vasiliy G Tolstov wrote:
> On Tue, 2011-01-18 at 11:57 +0100, Daniel Poelzleithner wrote:
> > Hi all,
> > 
> > I'm happy to announce the release of ulatencyd 0.3.1
> mobile build # cmake ../ulatencyd-0.3.1/
> -- The C compiler identification is unknown
> CMake Error at /usr/share/cmake/Modules/CMakeCInformation.cmake:37
> (GET_FILENAME_COMPONENT):
>   get_filename_component called with incorrect number of arguments
> Call Stack (most recent call first):
>   CMakeLists.txt:2 (project)
> 
> 
> CMake Error: your C compiler: "" was not found.   Please set
> CMAKE_C_COMPILER to a valid compiler path or name.
> -- Configuring incomplete, errors occurred!
> 
my mistake:
need to add -DCMAKE_C_COMPILER=gcc to cmake

