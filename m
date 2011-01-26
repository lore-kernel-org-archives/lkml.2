Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1AZQ7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:59:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40805 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1AZQ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:59:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ftjGG+ScmHU787+rk/VBQEpC28B9h6ruOO0tbebWa/LnXv+WM9+NUAMbdCW9mP5pb+
         6RZ/Jr02bN4k6ZTEd7dtH6SwXS+5VrcBo/TR0rrZMxw/kwhB9q9DmeAfK3ojF1i2mCGO
         cBXXCY2vtsLk1mP1s8gIxtCXsfn6LJfz7WuDQ=
Subject: [PATCH] Staging: Westbridge: fix EXPORT_SYMBOL errors reported by
 checkpatch.pl
From: Sutharsan <sutharsan.tech@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, david.cross@cypress.com, srmt@cypress.com
Content-Type: text/plain
Date: Wed, 26 Jan 2011 08:58:54 -0800
Message-Id: <1296061134.4116.7.camel@sutharsan-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sutharsan Ramamoorthy <srmt@cypress.com>

This patch fixes errors reported by checkpatch.pl
in westbridge device controller driver in the staging tree.
File containing EXPORT_SYMBOL() macros for all the APIs exported
by the westbridge software has been removed. EXPORT_SYMBOL() 
macros are added after the corresponding function definitions.

Signed-off-by: Sutharsan Ramamoorthy <srmt@cypress.com>

---

diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/api/src/cyasmisc.c linux-2.6.37-wb/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/api/src/cyasmisc.c	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-wb/drivers/staging/westbridge/astoria/api/src/cyasmisc.c	2011-01-19 11:55:07.842669281 -0800
@@ -926,6 +926,8 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_misc_get_firmware_version);
+
 static cy_as_return_status_t
 my_handle_response_read_m_c_u_register(cy_as_device *dev_p,
 				cy_as_ll_request_response *req_p,
@@ -1115,7 +1117,7 @@ destroy:
 
 	return ret;
 }
-
+EXPORT_SYMBOL(cy_as_misc_read_m_c_u_register);
 
 cy_as_return_status_t
 cy_as_misc_write_m_c_u_register(cy_as_device_handle handle,
@@ -1336,6 +1338,7 @@ cy_as_misc_reset(cy_as_device_handle han
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_misc_reset);
 
 static cy_as_return_status_t
 get_unallocated_resource(cy_as_device *dev_p, cy_as_resource_type resource)
@@ -1508,6 +1511,8 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_misc_acquire_resource);
+
 cy_as_return_status_t
 cy_as_misc_release_resource(cy_as_device_handle handle,
 	cy_as_resource_type resource)
@@ -1560,6 +1565,7 @@ cy_as_misc_release_resource(cy_as_device
 
 	return CY_AS_ERROR_SUCCESS;
 }
+EXPORT_SYMBOL(cy_as_misc_release_resource);
 
 cy_as_return_status_t
 cy_as_misc_set_trace_level(cy_as_device_handle handle,
@@ -1718,6 +1724,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_misc_heart_beat_control);
 
 static cy_as_return_status_t
 my_set_sd_clock_freq(
@@ -1805,6 +1812,7 @@ cy_as_misc_set_low_speed_sd_freq(
 
 	return my_set_sd_clock_freq(dev_p, 0, (uint8_t)setting, cb, client);
 }
+EXPORT_SYMBOL(cy_as_misc_set_low_speed_sd_freq);
 
 cy_as_return_status_t
 cy_as_misc_set_high_speed_sd_freq(
@@ -1830,6 +1838,7 @@ cy_as_misc_set_high_speed_sd_freq(
 
 	return my_set_sd_clock_freq(dev_p, 1, (uint8_t)setting, cb, client);
 }
+EXPORT_SYMBOL(cy_as_misc_set_high_speed_sd_freq);
 
 cy_as_return_status_t
 cy_as_misc_get_gpio_value(cy_as_device_handle handle,
@@ -1921,7 +1930,7 @@ destroy:
 
 	return ret;
 }
-
+EXPORT_SYMBOL(cy_as_misc_get_gpio_value);
 
 cy_as_return_status_t
 cy_as_misc_set_gpio_value(cy_as_device_handle handle,
@@ -2020,6 +2029,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_misc_set_gpio_value);
 
 static cy_as_return_status_t
 my_enter_standby(cy_as_device *dev_p, cy_bool pin)
@@ -2213,6 +2223,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_misc_enter_standby);
 
 cy_as_return_status_t
 cy_as_misc_enter_standby_e_x_u(cy_as_device_handle handle,
@@ -2425,6 +2436,7 @@ try_wakeup_again:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_misc_leave_standby);
 
 cy_as_return_status_t
 cy_as_misc_register_callback(
@@ -2526,7 +2538,7 @@ destroy:
 
 	return ret;
 }
-
+EXPORT_SYMBOL(cy_as_misc_storage_changed);
 
 cy_as_return_status_t
 cy_as_misc_enter_suspend(
@@ -2634,6 +2646,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_misc_enter_suspend);
 
 cy_as_return_status_t
 cy_as_misc_leave_suspend(
@@ -2704,6 +2717,7 @@ cy_as_misc_leave_suspend(
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_misc_leave_suspend);
 
 cy_as_return_status_t
 cy_as_misc_reserve_l_n_a_boot_area(cy_as_device_handle handle,
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/api/src/cyasmtp.c linux-2.6.37-wb/drivers/staging/westbridge/astoria/api/src/cyasmtp.c
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/api/src/cyasmtp.c	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-wb/drivers/staging/westbridge/astoria/api/src/cyasmtp.c	2011-01-14 12:04:06.786111000 -0800
@@ -402,6 +402,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_mtp_start);
 
 static cy_as_return_status_t
 my_handle_response_mtp_stop(cy_as_device *dev_p,
@@ -744,6 +745,7 @@ cy_as_mtp_init_send_object(cy_as_device_
 		client, CY_RQT_INIT_SEND_OBJECT);
 
 }
+EXPORT_SYMBOL(cy_as_mtp_init_send_object);
 
 cy_as_return_status_t
 cy_as_mtp_init_get_object(cy_as_device_handle handle,
@@ -763,6 +765,7 @@ cy_as_mtp_init_get_object(cy_as_device_h
 		transaction_id, cb, client, CY_RQT_INIT_GET_OBJECT);
 
 }
+EXPORT_SYMBOL(cy_as_mtp_init_get_object);
 
 static cy_as_return_status_t
 my_handle_response_cancel_send_object(cy_as_device *dev_p,
@@ -850,6 +853,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_mtp_cancel_send_object);
 
 static cy_as_return_status_t
 my_handle_response_cancel_get_object(cy_as_device *dev_p,
@@ -937,6 +941,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_mtp_cancel_get_object);
 
 cy_as_return_status_t
 cy_as_mtp_send_block_table(cy_as_device_handle handle,
@@ -1058,6 +1063,7 @@ cy_as_mtp_storage_only_start(cy_as_devic
 	dev_p->is_storage_only_mode = cy_true;
 	return CY_AS_ERROR_SUCCESS;
 }
+EXPORT_SYMBOL(cy_as_mtp_storage_only_start);
 
 cy_as_return_status_t
 cy_as_mtp_storage_only_stop(cy_as_device_handle handle,
@@ -1126,3 +1132,5 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_mtp_storage_only_stop);
+
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/api/src/cyasstorage.c linux-2.6.37-wb/drivers/staging/westbridge/astoria/api/src/cyasstorage.c
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/api/src/cyasstorage.c	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-wb/drivers/staging/westbridge/astoria/api/src/cyasstorage.c	2011-01-14 16:05:22.990611000 -0800
@@ -522,7 +522,7 @@ destroy:
 
 	return ret;
 }
-
+EXPORT_SYMBOL(cy_as_storage_start);
 
 static cy_as_return_status_t
 my_handle_response_storage_stop(cy_as_device *dev_p,
@@ -632,6 +632,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_storage_stop);
 
 cy_as_return_status_t
 cy_as_storage_register_callback(cy_as_device_handle handle,
@@ -655,7 +656,7 @@ cy_as_storage_register_callback(cy_as_de
 
 	return CY_AS_ERROR_SUCCESS;
 }
-
+EXPORT_SYMBOL(cy_as_storage_register_callback);
 
 
 static cy_as_return_status_t
@@ -783,6 +784,7 @@ cy_as_storage_claim(cy_as_device_handle 
 	return my_storage_claim(dev_p, NULL, bus, device,
 		CY_AS_REQUEST_RESPONSE_MS, cb, client);
 }
+EXPORT_SYMBOL(cy_as_storage_claim);
 
 static cy_as_return_status_t
 my_handle_response_storage_release(cy_as_device *dev_p,
@@ -911,6 +913,7 @@ cy_as_storage_release(cy_as_device_handl
 	return my_storage_release(dev_p, NULL, bus, device,
 		CY_AS_REQUEST_RESPONSE_MS, cb, client);
 }
+EXPORT_SYMBOL(cy_as_storage_release);
 
 static cy_as_return_status_t
 my_handle_response_storage_query_bus(cy_as_device *dev_p,
@@ -1059,6 +1062,7 @@ cy_as_storage_query_bus(cy_as_device_han
 	return my_storage_query_bus(dev_p, bus, cy_as_media_max_media_value,
 		CY_AS_REQUEST_RESPONSE_MS, count, cb, client);
 }
+EXPORT_SYMBOL(cy_as_storage_query_bus);
 
 cy_as_return_status_t
 cy_as_storage_query_media(cy_as_device_handle handle,
@@ -1086,6 +1090,7 @@ cy_as_storage_query_media(cy_as_device_h
 	return my_storage_query_bus(dev_p, bus, type, CY_AS_REQUEST_RESPONSE_EX,
 			count, cb, client);
 }
+EXPORT_SYMBOL(cy_as_storage_query_media);
 
 static cy_as_return_status_t
 my_handle_response_storage_query_device(cy_as_device *dev_p,
@@ -1260,6 +1265,7 @@ cy_as_storage_query_device(cy_as_device_
 		CY_AS_REQUEST_RESPONSE_MS, data_p->bus,
 			data_p->device, cb, client);
 }
+EXPORT_SYMBOL(cy_as_storage_query_device);
 
 static cy_as_return_status_t
 my_handle_response_storage_query_unit(cy_as_device *dev_p,
@@ -1434,7 +1440,7 @@ cy_as_storage_query_unit(cy_as_device_ha
 	return my_storage_query_unit(dev_p, data_p, CY_AS_REQUEST_RESPONSE_MS,
 		data_p->bus, data_p->device, data_p->unit, cb, client);
 }
-
+EXPORT_SYMBOL(cy_as_storage_query_unit);
 
 static cy_as_return_status_t
 cy_as_get_block_size(cy_as_device *dev_p,
@@ -1615,6 +1621,7 @@ cy_as_storage_device_control(cy_as_devic
 	return my_storage_device_control(dev_p, bus, device, card_detect_en,
 		write_prot_en, config_detect, cb, client);
 }
+EXPORT_SYMBOL(cy_as_storage_device_control);
 
 static void
 cy_as_async_storage_callback(cy_as_device *dev_p,
@@ -2069,6 +2076,7 @@ cy_as_storage_read(cy_as_device_handle h
 		CY_RQT_READ_BLOCK, bus, device,
 		unit, block, data_p, num_blocks);
 }
+EXPORT_SYMBOL(cy_as_storage_read);
 
 cy_as_return_status_t
 cy_as_storage_write(cy_as_device_handle handle,
@@ -2089,7 +2097,7 @@ cy_as_storage_write(cy_as_device_handle 
 		CY_RQT_WRITE_BLOCK, bus, device,
 		unit, block, data_p, num_blocks);
 }
-
+EXPORT_SYMBOL(cy_as_storage_write);
 
 cy_as_return_status_t
 cy_as_storage_read_async(cy_as_device_handle handle,
@@ -2110,6 +2118,7 @@ cy_as_storage_read_async(cy_as_device_ha
 		CY_AS_REQUEST_RESPONSE_MS, bus, device, unit,
 		block, data_p, num_blocks, NULL, callback);
 }
+EXPORT_SYMBOL(cy_as_storage_read_async);
 
 cy_as_return_status_t
 cy_as_storage_write_async(cy_as_device_handle handle,
@@ -2133,7 +2142,7 @@ cy_as_storage_write_async(cy_as_device_h
 		CY_AS_REQUEST_RESPONSE_MS, bus, device, unit, block,
 		data_p, num_blocks, NULL, callback);
 }
-
+EXPORT_SYMBOL(cy_as_storage_write_async);
 
 static void
 my_storage_cancel_callback(
@@ -2196,6 +2205,7 @@ cy_as_storage_cancel_async(cy_as_device_
 
 	return CY_AS_ERROR_SUCCESS;
 }
+EXPORT_SYMBOL(cy_as_storage_cancel_async);
 
 /*
  * This function does all the API side clean-up associated with
@@ -2374,6 +2384,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_storage_sd_register_read);
 
 cy_as_return_status_t
 cy_as_storage_create_p_partition(
@@ -2450,6 +2461,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_storage_create_p_partition);
 
 cy_as_return_status_t
 cy_as_storage_remove_p_partition(
@@ -2519,6 +2531,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_storage_remove_p_partition);
 
 static cy_as_return_status_t
 my_handle_response_get_transfer_amount(cy_as_device *dev_p,
@@ -2621,6 +2634,7 @@ destroy:
 	return ret;
 
 }
+EXPORT_SYMBOL(cy_as_storage_get_transfer_amount);
 
 cy_as_return_status_t
 cy_as_storage_erase(
@@ -2722,6 +2736,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_storage_erase);
 
 static void
 cy_as_storage_func_callback(cy_as_device *dev_p,
@@ -3005,6 +3020,7 @@ cy_as_sdio_direct_read(
 	return cy_as_sdio_direct_io(handle, bus, device, n_function_no,
 		address, misc_buf, 0x00, cy_false, data_p);
 }
+EXPORT_SYMBOL(cy_as_sdio_direct_read);
 
 cy_as_return_status_t
 cy_as_sdio_direct_write(
@@ -3020,6 +3036,7 @@ cy_as_sdio_direct_write(
 	return cy_as_sdio_direct_io(handle, bus, device, n_function_no,
 		address, misc_buf, argument, cy_true, data_p);
 }
+EXPORT_SYMBOL(cy_as_sdio_direct_write);
 
 /*Cmd53 IO*/
 cy_as_return_status_t
@@ -3403,6 +3420,7 @@ cy_as_sdio_extended_read(
 		n_function_no, address, misc_buf, argument, cy_false,
 		data_p, callback);
 }
+EXPORT_SYMBOL(cy_as_sdio_extended_read);
 
 /* CMD53 Extended Write*/
 cy_as_return_status_t
@@ -3426,7 +3444,7 @@ cy_as_sdio_extended_write(
 		n_function_no, address, misc_buf, argument, cy_true,
 		data_p, callback);
 }
-
+EXPORT_SYMBOL(cy_as_sdio_extended_write);
 
 /* Read the CIS info tuples for the given function and Tuple ID*/
 cy_as_return_status_t
@@ -3617,6 +3635,7 @@ destroy:
 		cy_as_ll_destroy_response(dev_p, reply_p);
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_sdio_query_card);
 
 /*Reset SDIO card. */
 cy_as_return_status_t
@@ -3767,6 +3786,7 @@ destroy:
 		cy_as_ll_destroy_response(dev_p, reply_p);
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_sdio_init_function);
 
 /*Query individual functions. */
 cy_as_return_status_t
@@ -4066,6 +4086,7 @@ cy_as_sdio_set_blocksize(
 			bus, n_function_no, blocksize);
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_sdio_set_blocksize);
 
 /* Deinitialize an SDIO function*/
 cy_as_return_status_t
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/api/src/cyasusb.c linux-2.6.37-wb/drivers/staging/westbridge/astoria/api/src/cyasusb.c
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/api/src/cyasusb.c	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-wb/drivers/staging/westbridge/astoria/api/src/cyasusb.c	2011-01-14 11:50:16.350111000 -0800
@@ -800,6 +800,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_start);
 
 void
 cy_as_usb_reset(cy_as_device *dev_p)
@@ -977,6 +978,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_stop);
 
 /*
 * This function registers a callback to be called when
@@ -1004,7 +1006,7 @@ cy_as_usb_register_callback(cy_as_device
 	dev_p->usb_event_cb_ms = callback;
 	return CY_AS_ERROR_SUCCESS;
 }
-
+EXPORT_SYMBOL(cy_as_usb_register_callback);
 
 static cy_as_return_status_t
 my_handle_response_no_data(cy_as_device *dev_p,
@@ -1124,6 +1126,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_connect);
 
 static cy_as_return_status_t
 my_handle_response_disconnect(cy_as_device *dev_p,
@@ -1222,6 +1225,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_disconnect);
 
 static cy_as_return_status_t
 my_handle_response_set_enum_config(cy_as_device *dev_p,
@@ -1437,7 +1441,7 @@ cy_as_usb_set_enum_config(cy_as_device_h
 			client
 		);
 }
-
+EXPORT_SYMBOL(cy_as_usb_set_enum_config);
 
 static cy_as_return_status_t
 my_handle_response_get_enum_config(cy_as_device *dev_p,
@@ -1622,7 +1626,7 @@ cy_as_usb_get_enum_config(cy_as_device_h
 	return my_usb_get_enum_config(handle,
 		CY_AS_REQUEST_RESPONSE_MS, config_p, cb, client);
 }
-
+EXPORT_SYMBOL(cy_as_usb_get_enum_config);
 
 /*
 * This method sets the USB descriptor for a given entity.
@@ -1705,6 +1709,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_set_descriptor);
 
 /*
  * This method clears all descriptors that were previously
@@ -1771,6 +1776,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_clear_descriptors);
 
 static cy_as_return_status_t
 my_handle_response_get_descriptor(cy_as_device *dev_p,
@@ -1881,6 +1887,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_get_descriptor);
 
 cy_as_return_status_t
 cy_as_usb_set_physical_configuration(cy_as_device_handle handle,
@@ -1910,6 +1917,7 @@ cy_as_usb_set_physical_configuration(cy_
 
 	return CY_AS_ERROR_SUCCESS;
 }
+EXPORT_SYMBOL(cy_as_usb_set_physical_configuration);
 
 static cy_bool
 is_physical_valid(uint8_t config, cy_as_end_point_number_t ep)
@@ -2027,6 +2035,7 @@ cy_as_usb_set_end_point_config(cy_as_dev
 	return cy_as_dma_enable_end_point(dev_p, ep,
 		config_p->enabled, (cy_as_dma_direction)config_p->dir);
 }
+EXPORT_SYMBOL(cy_as_usb_set_end_point_config);
 
 cy_as_return_status_t
 cy_as_usb_get_end_point_config(cy_as_device_handle handle,
@@ -2053,6 +2062,7 @@ cy_as_usb_get_end_point_config(cy_as_dev
 
 	return CY_AS_ERROR_SUCCESS;
 }
+EXPORT_SYMBOL(cy_as_usb_get_end_point_config);
 
 /*
 * Commit the configuration of the various endpoints to the hardware.
@@ -2180,6 +2190,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_commit_config);
 
 static void
 sync_request_callback(cy_as_device *dev_p,
@@ -2381,6 +2392,7 @@ cy_as_usb_read_data(cy_as_device_handle 
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_read_data);
 
 cy_as_return_status_t
 cy_as_usb_read_data_async(cy_as_device_handle handle,
@@ -2459,6 +2471,7 @@ cy_as_usb_read_data_async(cy_as_device_h
 	}
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_read_data_async);
 
 cy_as_return_status_t
 cy_as_usb_write_data(cy_as_device_handle handle,
@@ -2571,6 +2584,7 @@ cy_as_usb_write_data(cy_as_device_handle
 	ret = dev_p->usb_error;
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_write_data);
 
 static void
 mtp_write_callback(
@@ -2736,6 +2750,7 @@ cy_as_usb_write_data_async(cy_as_device_
 
 	return CY_AS_ERROR_SUCCESS;
 }
+EXPORT_SYMBOL(cy_as_usb_write_data_async);
 
 static void
 my_usb_cancel_async_callback(
@@ -2827,6 +2842,7 @@ cy_as_usb_cancel_async(cy_as_device_hand
 
 	return CY_AS_ERROR_SUCCESS;
 }
+EXPORT_SYMBOL(cy_as_usb_cancel_async);
 
 static void
 cy_as_usb_ack_callback(
@@ -3212,7 +3228,7 @@ cy_as_usb_set_nak(cy_as_device_handle ha
 	return cy_as_usb_nak_stall_request(handle, ep,
 		CY_RQT_ENDPOINT_SET_NAK, cy_true, 0, cb, client);
 }
-
+EXPORT_SYMBOL(cy_as_usb_set_nak);
 
 cy_as_return_status_t
 cy_as_usb_clear_nak(cy_as_device_handle handle,
@@ -3238,6 +3254,7 @@ cy_as_usb_clear_nak(cy_as_device_handle 
 	return cy_as_usb_nak_stall_request(handle, ep,
 		CY_RQT_ENDPOINT_SET_NAK, cy_false, 0, cb, client);
 }
+EXPORT_SYMBOL(cy_as_usb_clear_nak);
 
 cy_as_return_status_t
 cy_as_usb_get_nak(cy_as_device_handle handle,
@@ -3265,7 +3282,7 @@ cy_as_usb_get_nak(cy_as_device_handle ha
 		CY_RQT_GET_ENDPOINT_NAK, CY_RESP_ENDPOINT_NAK,
 		nak_p, cb, client);
 }
-
+EXPORT_SYMBOL(cy_as_usb_get_nak);
 
 cy_as_return_status_t
 cy_as_usb_set_stall(cy_as_device_handle handle,
@@ -3291,6 +3308,7 @@ cy_as_usb_set_stall(cy_as_device_handle 
 	return cy_as_usb_nak_stall_request(handle, ep,
 		CY_RQT_STALL_ENDPOINT, cy_true, 0, cb, client);
 }
+EXPORT_SYMBOL(cy_as_usb_set_stall);
 
 cy_as_return_status_t
 cy_as_usb_clear_stall(cy_as_device_handle handle,
@@ -3316,6 +3334,7 @@ cy_as_usb_clear_stall(cy_as_device_handl
 	return cy_as_usb_nak_stall_request(handle, ep,
 		CY_RQT_STALL_ENDPOINT, cy_false, 0, cb, client);
 }
+EXPORT_SYMBOL(cy_as_usb_clear_stall);
 
 cy_as_return_status_t
 cy_as_usb_get_stall(cy_as_device_handle handle,
@@ -3342,6 +3361,7 @@ cy_as_usb_get_stall(cy_as_device_handle 
 	return cy_as_usb_get_nak_stall(handle, ep,
 		CY_RQT_GET_STALL, CY_RESP_ENDPOINT_STALL, stall_p, cb, client);
 }
+EXPORT_SYMBOL(cy_as_usb_get_stall);
 
 cy_as_return_status_t
 cy_as_usb_signal_remote_wakeup(cy_as_device_handle handle,
@@ -3405,6 +3425,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_signal_remote_wakeup);
 
 cy_as_return_status_t
 cy_as_usb_set_m_s_report_threshold(cy_as_device_handle handle,
@@ -3482,6 +3503,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_set_m_s_report_threshold);
 
 cy_as_return_status_t
 cy_as_usb_select_m_s_partitions(
@@ -3563,6 +3585,7 @@ destroy:
 
 	return ret;
 }
+EXPORT_SYMBOL(cy_as_usb_select_m_s_partitions);
 
 static void
 cy_as_usb_func_callback(
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/device/cyandevice_export.h linux-2.6.37-wb/drivers/staging/westbridge/astoria/device/cyandevice_export.h
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/device/cyandevice_export.h	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-wb/drivers/staging/westbridge/astoria/device/cyandevice_export.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,132 +0,0 @@
-/*
-## cyandevice_export.h - Linux Antioch device driver file
-##
-## ===========================
-## Copyright (C) 2010  Cypress Semiconductor
-##
-## This program is free software; you can redistribute it and/or
-## modify it under the terms of the GNU General Public License
-## as published by the Free Software Foundation; either version 2
-## of the License, or (at your option) any later version.
-##
-## This program is distributed in the hope that it will be useful,
-## but WITHOUT ANY WARRANTY; without even the implied warranty of
-## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-## GNU General Public License for more details.
-##
-## You should have received a copy of the GNU General Public License
-## along with this program; if not, write to the Free Software
-## Foundation, Inc., 51 Franklin Street
-## Fifth Floor, Boston, MA  02110-1301, USA.
-## ===========================
-*/
-
-/*
- * Export Misc APIs that can be used from the other driver modules.
- * The APIs to create a device handle and download firmware are not exported
- * because they are expected to be used only by this kernel module.
- */
-EXPORT_SYMBOL(cy_as_misc_get_firmware_version);
-EXPORT_SYMBOL(cy_as_misc_read_m_c_u_register);
-EXPORT_SYMBOL(cy_as_misc_reset);
-EXPORT_SYMBOL(cy_as_misc_acquire_resource);
-EXPORT_SYMBOL(cy_as_misc_release_resource);
-EXPORT_SYMBOL(cy_as_misc_enter_standby);
-EXPORT_SYMBOL(cy_as_misc_leave_standby);
-EXPORT_SYMBOL(cy_as_misc_enter_suspend);
-EXPORT_SYMBOL(cy_as_misc_leave_suspend);
-EXPORT_SYMBOL(cy_as_misc_storage_changed);
-EXPORT_SYMBOL(cy_as_misc_heart_beat_control);
-EXPORT_SYMBOL(cy_as_misc_get_gpio_value);
-EXPORT_SYMBOL(cy_as_misc_set_gpio_value);
-EXPORT_SYMBOL(cy_as_misc_set_low_speed_sd_freq);
-EXPORT_SYMBOL(cy_as_misc_set_high_speed_sd_freq);
-
-/*
- * Export the USB APIs that can be used by the dependent kernel modules.
- */
-EXPORT_SYMBOL(cy_as_usb_set_end_point_config);
-EXPORT_SYMBOL(cy_as_usb_read_data_async);
-EXPORT_SYMBOL(cy_as_usb_write_data_async);
-EXPORT_SYMBOL(cy_as_usb_cancel_async);
-EXPORT_SYMBOL(cy_as_usb_set_stall);
-EXPORT_SYMBOL(cy_as_usb_clear_stall);
-EXPORT_SYMBOL(cy_as_usb_connect);
-EXPORT_SYMBOL(cy_as_usb_disconnect);
-EXPORT_SYMBOL(cy_as_usb_start);
-EXPORT_SYMBOL(cy_as_usb_stop);
-EXPORT_SYMBOL(cy_as_usb_set_enum_config);
-EXPORT_SYMBOL(cy_as_usb_get_enum_config);
-EXPORT_SYMBOL(cy_as_usb_set_physical_configuration);
-EXPORT_SYMBOL(cy_as_usb_register_callback);
-EXPORT_SYMBOL(cy_as_usb_commit_config);
-EXPORT_SYMBOL(cy_as_usb_set_descriptor);
-EXPORT_SYMBOL(cy_as_usb_clear_descriptors);
-EXPORT_SYMBOL(cy_as_usb_get_descriptor);
-EXPORT_SYMBOL(cy_as_usb_get_end_point_config);
-EXPORT_SYMBOL(cy_as_usb_read_data);
-EXPORT_SYMBOL(cy_as_usb_write_data);
-EXPORT_SYMBOL(cy_as_usb_get_stall);
-EXPORT_SYMBOL(cy_as_usb_set_nak);
-EXPORT_SYMBOL(cy_as_usb_clear_nak);
-EXPORT_SYMBOL(cy_as_usb_get_nak);
-EXPORT_SYMBOL(cy_as_usb_signal_remote_wakeup);
-EXPORT_SYMBOL(cy_as_usb_set_m_s_report_threshold);
-EXPORT_SYMBOL(cy_as_usb_select_m_s_partitions);
-
-/*
- * Export all Storage APIs that can be used by dependent kernel modules.
- */
-EXPORT_SYMBOL(cy_as_storage_start);
-EXPORT_SYMBOL(cy_as_storage_stop);
-EXPORT_SYMBOL(cy_as_storage_register_callback);
-EXPORT_SYMBOL(cy_as_storage_query_bus);
-EXPORT_SYMBOL(cy_as_storage_query_media);
-EXPORT_SYMBOL(cy_as_storage_query_device);
-EXPORT_SYMBOL(cy_as_storage_query_unit);
-EXPORT_SYMBOL(cy_as_storage_device_control);
-EXPORT_SYMBOL(cy_as_storage_claim);
-EXPORT_SYMBOL(cy_as_storage_release);
-EXPORT_SYMBOL(cy_as_storage_read);
-EXPORT_SYMBOL(cy_as_storage_write);
-EXPORT_SYMBOL(cy_as_storage_read_async);
-EXPORT_SYMBOL(cy_as_storage_write_async);
-EXPORT_SYMBOL(cy_as_storage_cancel_async);
-EXPORT_SYMBOL(cy_as_storage_sd_register_read);
-EXPORT_SYMBOL(cy_as_storage_create_p_partition);
-EXPORT_SYMBOL(cy_as_storage_remove_p_partition);
-EXPORT_SYMBOL(cy_as_storage_get_transfer_amount);
-EXPORT_SYMBOL(cy_as_storage_erase);
-
-EXPORT_SYMBOL(cy_as_sdio_query_card);
-EXPORT_SYMBOL(cy_as_sdio_init_function);
-EXPORT_SYMBOL(cy_as_sdio_set_blocksize);
-EXPORT_SYMBOL(cy_as_sdio_direct_read);
-EXPORT_SYMBOL(cy_as_sdio_direct_write);
-EXPORT_SYMBOL(cy_as_sdio_extended_read);
-EXPORT_SYMBOL(cy_as_sdio_extended_write);
-
-EXPORT_SYMBOL(cy_as_hal_alloc);
-EXPORT_SYMBOL(cy_as_hal_free);
-EXPORT_SYMBOL(cy_as_hal_sleep);
-EXPORT_SYMBOL(cy_as_hal_create_sleep_channel);
-EXPORT_SYMBOL(cy_as_hal_destroy_sleep_channel);
-EXPORT_SYMBOL(cy_as_hal_sleep_on);
-EXPORT_SYMBOL(cy_as_hal_wake);
-EXPORT_SYMBOL(cy_as_hal_mem_set);
-
-EXPORT_SYMBOL(cy_as_mtp_storage_only_start);
-EXPORT_SYMBOL(cy_as_mtp_storage_only_stop);
-EXPORT_SYMBOL(cy_as_mtp_start);
-EXPORT_SYMBOL(cy_as_mtp_init_send_object);
-EXPORT_SYMBOL(cy_as_mtp_init_get_object);
-EXPORT_SYMBOL(cy_as_mtp_cancel_send_object);
-EXPORT_SYMBOL(cy_as_mtp_cancel_get_object);
-
-#ifdef __CY_ASTORIA_SCM_KERNEL_HAL__
-/* Functions in the SCM kernel HAL implementation only. */
-EXPORT_SYMBOL(cy_as_hal_enable_scatter_list);
-EXPORT_SYMBOL(cy_as_hal_disable_scatter_list);
-#endif
-
-/*[]*/
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c linux-2.6.37-wb/drivers/staging/westbridge/astoria/device/cyasdevice.c
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-wb/drivers/staging/westbridge/astoria/device/cyasdevice.c	2011-01-19 14:01:39.139418883 -0800
@@ -40,9 +40,6 @@
 #include "../include/linux/westbridge/cyashal.h"
 #include "../include/linux/westbridge/cyasregs.h"
 
-/* API exports include file */
-#include "cyandevice_export.h"
-
 typedef struct cyasdevice {
 		/* Handle to the Antioch device */
 		cy_as_device_handle			dev_handle;

